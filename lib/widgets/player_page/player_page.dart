import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/artist.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/widgets/_common/custom_auto_size_text.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/edit_story_page/edit_story_page.dart';
import 'package:storify/widgets/more_info_menu_body/more_info_menu_body.dart';
import 'package:storify/widgets/player_page/player_carousel.dart';
import 'package:storify/widgets/player_page/player_progress_bar.dart';

// TODO Refactor into smaller, reusable widgets

class PlayerPage extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerPage> {
  PlayerTracksBloc _playerTracksBloc;
  FirebaseDB database = FirebaseDB();

  @override
  void initState() {
    super.initState();
    _playerTracksBloc = BlocProvider.of<PlayerTracksBloc>(context);
  }

  void _handleTrackChanged(int index) {
    _playerTracksBloc.add(PlayerTracksTrackSelected(selectedTrackIndex: index));
  }

  void _onEditOrAddPressed(
      String storyText, Track currentTrack, Playlist playlist) {
    EditStoryPage.show(
      context,
      track: currentTrack,
      originalStoryText: storyText,
      onStoryTextEdited: (String newText) => _handleEditStoryText(
          newStoryText: newText,
          currentTrack: currentTrack,
          playlist: playlist),
    );
  }

  Future<void> _handleEditStoryText(
      {@required String newStoryText,
      @required Track currentTrack,
      @required Playlist playlist}) async {
    try {
      final playlistId = playlist.id;
      final trackId = currentTrack.id;
      await database.setStory(newStoryText, playlistId, trackId);
      CustomToast.showTextToast(text: 'Updated', toastType: ToastType.success);
    } catch (e) {
      print(e);
      CustomToast.showTextToast(
          text: 'Failed to update story', toastType: ToastType.error);
    }
  }

  String _artistNames(List<Artist> artists) {
    return artists.map((artist) => artist.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerTracksBloc, PlayerTracksState>(
        builder: (context, state) {
      if (state is PlayerTracksInitial) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context, state.playlist),
          body: Center(
            child: StatusIndicator(
              message: 'Loading Tracks',
              status: Status.loading,
            ),
          ),
        );
      }
      if (state is PlayerTracksFailure) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context, state.playlist),
          body: Center(
            child: StatusIndicator(
              message: 'Failed to load tracks',
              status: Status.error,
            ),
          ),
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
                appBar: _buildAppBar(context, state.playlist),
                body: _buildContent(state.playlist, state.tracks,
                    state.currentTrack, state.currentTrackArtistImageUrl),
              ),
            )
          ],
        );
      }

      return Container();
    });
  }

  AppBar _buildAppBar(BuildContext context, Playlist playlist) {
    return AppBar(
      title: Text(
        playlist.name,
        style: TextStyles.appBarTitle.copyWith(letterSpacing: 0),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: CustomColors.secondaryTextColor, //change your color here
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'MORE',
            style: TextStyles.smallButtonText,
          ),
          onPressed: () => OverlayMenu.show(context,
              menuBody: MoreInfoMenuBody(
                playlist: playlist,
              )),
        ),
      ],
    );
  }

  Widget _buildContent(Playlist playlist, List<Track> tracks,
      Track currentTrack, String artistImageUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, bottom: 36.0),
      child: StreamBuilder(
          stream: database.storyStream(
              playlistId: playlist.id, trackId: currentTrack.id),
          builder: (context, snapshot) {
            final storyText = snapshot?.data ?? '';
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildTrackInfo(
                        storyText, currentTrack, artistImageUrl),
                  ),
                ),
                Column(children: [
                  Column(children: [
                    SizedBox(
                      height: 8.0,
                    ),
                    CustomRoundedButton(
                      size: ButtonSize.small,
                      buttonText:
                          storyText == '' ? 'ADD A STORY' : 'EDIT YOUR STORY',
                      onPressed: () => _onEditOrAddPressed(
                          storyText, currentTrack, playlist),
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
                        onPageChanged: (index, _) => _handleTrackChanged(index),
                      ),
                      PlayerProgressBar(
                        totalValue: 360,
                        initialValue: 270,
                        size: 72.0,
                      ),
                    ],
                  )
                ]),
              ],
            );
          }),
    );
  }

  Column _buildTrackInfo(
      String storyText, Track currentTrack, String artistImageUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 48.0,
        ),
        CircleAvatar(
            radius: 54.0,
            backgroundColor: Colors.transparent,
            backgroundImage: CustomImageProvider.cachedImage(artistImageUrl)),
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            Text(_artistNames(currentTrack.artists),
                textAlign: TextAlign.center,
                style: TextStyles.secondary.copyWith(fontSize: 16.0)),
            CustomAutoSizeText(
              currentTrack.name,
              maxLines: 1,
              minFontSize: 32.0,
              fontSize: 48.0,
              overflowReplacement: CustomAutoSizeText(currentTrack.name,
                  maxLines: 2,
                  minFontSize: 32.0,
                  fontSize: 32.0,
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
        ),
        SizedBox(
          height: 16.0,
        ),
        if (storyText != '')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            width: double.infinity,
            child: Text(
              storyText,
              textAlign: TextAlign.start,
              style: TextStyles.secondary.copyWith(fontSize: 18.0, height: 1.5),
            ),
          ),
      ],
    );
  }
}
