import 'dart:ui';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/edit_story_page/edit_story_page.dart';
import 'package:storify/widgets/player_page/player_carousel.dart';
import 'package:storify/widgets/player_page/player_page_app_bar.dart';
import 'package:storify/widgets/player_page/player_page_error.dart';
import 'package:storify/widgets/player_page/player_page_loading.dart';
import 'package:storify/widgets/player_page/player_play_button.dart';
import 'package:storify/widgets/player_page/player_progress_bar.dart';
import 'package:storify/widgets/player_page/player_track_info.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();

  static Widget create({@required Playlist playlist}) {
    return BlocProvider(
      create: (_) => PlayerTracksBloc(
        playlist: playlist,
      )..add(PlayerTracksFetched()),
      child: Builder(builder: (context) {
        return BlocProvider(
            create: (_) => CurrentPlaybackBloc(
                playerTracksBloc: BlocProvider.of<PlayerTracksBloc>(context))
              ..add(CurrentPlaybackLoaded()),
            child: PlayerPage());
      }),
    );
  }
}

class _PlayerState extends State<PlayerPage> with WidgetsBindingObserver {
  PlayerTracksBloc _playerTracksBloc;
  CurrentPlaybackBloc _currentPlaybackBloc;
  ScrollController _controller;
  CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _carouselController = CarouselController();
    _playerTracksBloc = BlocProvider.of<PlayerTracksBloc>(context);
    _currentPlaybackBloc = BlocProvider.of<CurrentPlaybackBloc>(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _handleTrackChanged(int index) {
    _controller.animateTo(0,
        duration: Constants.scrollResetDuration, curve: Curves.ease);
    _playerTracksBloc.add(PlayerTracksTrackSelected(selectedTrackIndex: index));
  }

  void _onEditOrAddPressed(
      String storyText, Track currentTrack, Playlist playlist) {
    EditStoryPage.show(context,
        track: currentTrack,
        originalStoryText: storyText,
        onStoryTextEdited: _handleEditStoryText);
  }

  void _onPlaylistNotOwned() {
    CustomToast.showTextToast(
        text: 'You can only add story to \nplaylists you\'ve created.',
        toastType: ToastType.warning);
  }

  Future<void> _onPlayButtonTapped() async {
    final playbackState = _currentPlaybackBloc.state;
    final playerTracksState = _playerTracksBloc.state;

    if (playbackState is CurrentPlaybackEmpty) {
      _currentPlaybackBloc.add(CurrentPlaybackPlayed());
    } else if (playbackState is CurrentPlaybackSuccess) {
      if (playerTracksState is PlayerTracksSuccess) {
        final isCurrentlyPlayingTrackSelected =
            playerTracksState.currentTrack.id == playbackState.playback.trackId;
        if (playbackState.playback.isPlaying &&
            isCurrentlyPlayingTrackSelected) {
          _currentPlaybackBloc.add(CurrentPlaybackPaused());
        } else {
          _currentPlaybackBloc.add(CurrentPlaybackPlayed(
              positionMs: isCurrentlyPlayingTrackSelected
                  ? playbackState.playback.progressMs
                  : 0));
        }
      }
    }
  }

  Future<void> _handleEditStoryText(String newStoryText) async {
    _playerTracksBloc.add(PlayerTrackStoryTextEdited(newStoryText));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _currentPlaybackBloc.add(CurrentPlaybackAppPaused());
    } else if (state == AppLifecycleState.resumed) {
      _currentPlaybackBloc.add(CurrentPlaybackAppResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PlayerTracksBloc, PlayerTracksState>(
            listenWhen: (previous, current) {
          if (previous is PlayerTracksSuccess &&
              current is PlayerTracksSuccess) {
            bool isPlayable =
                !previous.isAllDataLoaded && current.isAllDataLoaded;
            return isPlayable;
          }
          return false;
        }, listener: (context, state) {
          if (state is PlayerTracksSuccess && state.isAllDataLoaded) {
            _currentPlaybackBloc.add(CurrentPlaybackTrackChanged());
          }
        }),
        BlocListener<CurrentPlaybackBloc, CurrentPlaybackState>(
          listenWhen: (previous, current) {
            if (previous is CurrentPlaybackSuccess &&
                current is CurrentPlaybackSuccess) {
              return previous.playback.trackId != current.playback.trackId;
            }
            if (previous is CurrentPlaybackEmpty &&
                current is CurrentPlaybackSuccess) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            final playerTracksState = _playerTracksBloc.state;
            if (state is CurrentPlaybackSuccess &&
                playerTracksState is PlayerTracksSuccess) {
              final index = playerTracksState.tracks
                  .indexWhere((track) => track.id == state.playback.trackId);
              if (index > -1)
                _carouselController.animateToPage(index,
                    duration: Constants.carouselAnimationDuration);
            }
          },
        )
      ],
      child: BlocBuilder<PlayerTracksBloc, PlayerTracksState>(
          builder: (context, state) {
        if (state is PlayerTracksInitial) {
          return PlayerPageLoading(
            playlist: state.playlist,
          );
        }
        if (state is PlayerTracksFailure) {
          return PlayerPageError(
            playlist: state.playlist,
          );
        }

        if (state is PlayerTracksSuccess) {
          return Stack(
            children: [
              Image.network(
                state.currentTrack.albumImageUrl,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 35.0, sigmaY: 35.0),
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: Colors.transparent,
                  appBar: PlayerPageAppBar(playlist: state.playlist),
                  body: _buildContent(state),
                ),
              )
            ],
          );
        }

        return Container();
      }),
    );
  }

  Widget _buildContent(PlayerTracksSuccess state) {
    final playlist = state.playlist;
    final currentTrack = state.currentTrack;
    final artistImageUrl = state.currentTrackArtistImageUrl;
    final tracks = state.tracks;
    final storyText = state.storyText ?? '';

    final auth = context.read<SpotifyAuth>();
    bool isOwned = playlist.owner.id == auth.user.id;
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, bottom: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PlayerTrackInfo(
            storyText: storyText,
            artistImageUrl: artistImageUrl,
            currentTrack: currentTrack,
            controller: _controller,
          ),
          Column(children: [
            Column(children: [
              SizedBox(
                height: 8.0,
              ),
              CustomRoundedButton(
                size: ButtonSize.small,
                buttonText: storyText == '' ? 'ADD A STORY' : 'EDIT YOUR STORY',
                onPressed: isOwned
                    ? () =>
                        _onEditOrAddPressed(storyText, currentTrack, playlist)
                    : _onPlaylistNotOwned,
              ),
              SizedBox(
                height: 16.0,
              )
            ]),
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                PlayerCarousel(
                    tracks: tracks,
                    onPageChanged: _handleTrackChanged,
                    carouselController: _carouselController,
                    onPlayButtonTap: _onPlayButtonTapped),
                BlocBuilder<CurrentPlaybackBloc, CurrentPlaybackState>(
                  builder: (context, state) {
                    if (state is CurrentPlaybackSuccess &&
                        state.playback.trackId == currentTrack.id) {
                      final currentPosition =
                          state.playback.progressMs.toDouble();
                      final totalDuration = currentTrack.durationMs.toDouble();
                      if (currentPosition > totalDuration)
                        return PlaceHolderPlayerProgressBar();
                      return PlayerProgressBar(
                        totalValue: totalDuration,
                        initialValue: currentPosition,
                        size: 72.0,
                        innerWidget: PlayerPlayButton(
                          isPlaying: state.playback.isPlaying,
                        ),
                      );
                    }
                    return PlaceHolderPlayerProgressBar();
                  },
                ),
              ],
            )
          ]),
        ],
      ),
    );
  }
}

class PlaceHolderPlayerProgressBar extends StatelessWidget {
  const PlaceHolderPlayerProgressBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayerProgressBar(
      totalValue: 360,
      initialValue: 0,
      size: 72.0,
      innerWidget: PlayerPlayButton(
        isPlaying: false,
      ),
    );
  }
}
