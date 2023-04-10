import 'dart:ui';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/edit_story_page/edit_story_page.dart';
import 'package:storify/widgets/player_page/player_carousel.dart';
import 'package:storify/widgets/player_page/player_page_app_bar.dart';
import 'package:storify/widgets/player_page/player_page_error.dart';
import 'package:storify/widgets/player_page/player_page_loading.dart';
import 'package:storify/widgets/player_page/player_play_button.dart';
import 'package:storify/widgets/player_page/player_track_info.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key, this.isOpenedFromDeepLink = false})
      : super(key: key);
  final bool isOpenedFromDeepLink;

  @override
  _PlayerState createState() => _PlayerState();

  static Widget create(
      {required Playlist playlist, bool isOpenedFromDeepLink = false}) {
    return BlocProvider(
      create: (_) => PlayerTracksBloc(
        playlist: playlist,
      )..add(PlayerTracksFetched()),
      child: Builder(builder: (context) {
        return BlocProvider(
            create: (_) => CurrentPlaybackBloc(
                playerTracksBloc: BlocProvider.of<PlayerTracksBloc>(context))
              ..add(CurrentPlaybackLoaded()),
            child: PlayerPage(
              isOpenedFromDeepLink: isOpenedFromDeepLink,
            ));
      }),
    );
  }
}

class _PlayerState extends State<PlayerPage> with WidgetsBindingObserver {
  late PlayerTracksBloc _playerTracksBloc;
  late CurrentPlaybackBloc _currentPlaybackBloc;
  ScrollController? _controller;
  CarouselController? _carouselController;
  late FirebaseDB _firebaseDB;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _carouselController = CarouselController();
    _playerTracksBloc = BlocProvider.of<PlayerTracksBloc>(context);
    _currentPlaybackBloc = BlocProvider.of<CurrentPlaybackBloc>(context);
    _firebaseDB = FirebaseDB();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller!.dispose();
    super.dispose();
  }

  void _handleTrackChanged(int index) {
    _controller!.animateTo(0,
        duration: Constants.scrollResetDuration, curve: Curves.ease);
    _playerTracksBloc.add(PlayerTracksTrackSelected(selectedTrackIndex: index));
  }

  void _onEditOrAddPressed(
      String storyText, Track currentTrack, Playlist playlist) {
    EditStoryPage.show(context,
        track: currentTrack,
        originalStoryText: storyText,
        onStoryTextEdited: (String newText) =>
            _handleEditStoryText(newText, playlist, currentTrack.id));
  }

  Future<void> _onPlayButtonTapped() async {
    final CurrentPlaybackState playbackState = _currentPlaybackBloc.state;
    final PlayerTracksState playerTracksState = _playerTracksBloc.state;

    if (playbackState is CurrentPlaybackEmpty) {
      _currentPlaybackBloc.add(CurrentPlaybackPlayed());
    } else if (playbackState is CurrentPlaybackSuccess) {
      if (playerTracksState is PlayerTracksSuccess) {
        final isCurrentlyPlayingTrackSelected =
            playerTracksState.currentTrack.id == playbackState.playback.trackId;
        if (playbackState.playback.isPlaying! &&
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

  Future<void> _handleEditStoryText(
      String newStoryText, Playlist playlist, String? currentTrackId) async {
    try {
      await _firebaseDB.setStory(newStoryText, playlist, currentTrackId);
      _playerTracksBloc.add(PlayerTrackStoryTextAndArtistImageUrlLoaded());
      CustomToast.showTextToast(text: 'Updated', toastType: ToastType.success);
    } catch (e) {
      print(e);
      CustomToast.showTextToast(
          text: 'Failed to update story', toastType: ToastType.error);
    }
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
            if ((previous is CurrentPlaybackEmpty ||
                    previous is CurrentPlaybackInitial) &&
                current is CurrentPlaybackSuccess) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            final PlayerTracksState playerTracksState = _playerTracksBloc.state;
            if (state is CurrentPlaybackSuccess &&
                playerTracksState is PlayerTracksSuccess) {
              final index = playerTracksState.tracks
                  .indexWhere((track) => track.id == state.playback.trackId);
              if (index > -1)
                _carouselController!.animateToPage(index,
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
              state.currentTrack.albumImageUrl != null
                  ? Image.network(
                      state.currentTrack.albumImageUrl!,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Container(decoration: BoxDecoration(color: Colors.black)),
              Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 35.0, sigmaY: 35.0),
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: Colors.transparent,
                  appBar: PlayerPageAppBar(
                      playlist: state.playlist,
                      isOpenedFromDeepLink: widget.isOpenedFromDeepLink),
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
    final playlist = state.playlist!;
    final currentTrack = state.currentTrack;
    final artistImageUrl = state.currentTrackArtistImageUrl;
    final tracks = state.tracks;
    final storyText = state.storyText ?? '';
    final isLoaded = state.isAllDataLoaded;

    final auth = context.read<SpotifyAuth>();
    bool isOwned = playlist.owner.id == auth.user!.id;
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PlayerTrackInfo(
            storyText: storyText,
            artistImageUrl: artistImageUrl,
            currentTrack: currentTrack,
            controller: _controller,
          ),
          BlocBuilder<CurrentPlaybackBloc, CurrentPlaybackState>(
              builder: (context, state) {
            bool _isPlaying = false;
            if (state is CurrentPlaybackSuccess)
              _isPlaying = state.playback.isPlaying! &&
                  state.playback.playlistId == playlist.id;

            return Column(children: [
              Column(children: [
                SizedBox(
                  height: 8.0,
                ),
                if (isOwned && isLoaded)
                  CustomRoundedButton(
                    size: ButtonSize.small,
                    buttonText:
                        storyText == '' ? 'ADD A CAPTION' : 'EDIT CAPTION',
                    onPressed: () =>
                        _onEditOrAddPressed(storyText, currentTrack, playlist),
                  ),
                SizedBox(
                  height: 16.0,
                )
              ]),
              _buildProgressBar(state, currentTrack),
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      color: Colors.white10,
                    ),
                  ),
                  PlayerCarousel(
                      tracks: tracks,
                      onPageChanged: _handleTrackChanged,
                      carouselController: _carouselController,
                      onPlayButtonTap: _onPlayButtonTapped),
                  IgnorePointer(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 5,
                      padding: EdgeInsets.all(6.0),
                      decoration: new BoxDecoration(
                        color: Colors.black54,
                      ),
                      child: PlayerPlayButton(
                        isPlaying: _isPlaying,
                      ),
                    ),
                  )
                ],
              )
            ]);
          }),
        ],
      ),
    );
  }

  _buildProgressBar(CurrentPlaybackState state, Track currentTrack) {
    if (state is CurrentPlaybackSuccess &&
        state.playback.trackId == currentTrack.id) {
      final currentPosition = state.playback.progressMs!.toDouble();
      final totalDuration = currentTrack.durationMs!.toDouble();
      if (currentPosition > totalDuration)
        return PlaceHolderPlayerProgressBar();
      return LinearProgressIndicator(
        value: currentPosition / totalDuration,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        backgroundColor: Colors.white38,
      );
    }
    return PlaceHolderPlayerProgressBar();
  }
}

class PlaceHolderPlayerProgressBar extends StatelessWidget {
  const PlaceHolderPlayerProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.0,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      backgroundColor: Colors.white38,
    );
  }
}
