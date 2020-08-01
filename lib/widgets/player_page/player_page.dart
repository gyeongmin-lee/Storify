import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/artist.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/utils/debouncer.dart';
import 'package:storify/widgets/_common/custom_auto_size_text.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/edit_story_page/edit_story_page.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/more_info_menu_body/more_info_menu_body.dart';
import 'package:storify/widgets/player_page/player_carousel.dart';
import 'package:storify/widgets/player_page/player_progress_bar.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key key, @required this.playlist}) : super(key: key);
  final Playlist playlist;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerPage> {
  Future<List<Track>> _futureTracks;
  String storyText = '';
  int _currentTrackIndex = 0;
  String _currentTrackArtistImageUrl;
  Debouncer _debouncer = Debouncer(milliseconds: Constants.debounceMillisecond);

  @override
  void initState() {
    super.initState();
    _futureTracks = SpotifyApi.getTracks(widget.playlist.id);
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  Future<void> _loadArtistImage(Track currentTrack) async {
    final newImageUrl =
        await SpotifyApi.getArtistImageUrl(currentTrack.artists[0].href);
    setState(() {
      _currentTrackArtistImageUrl = newImageUrl;
    });
  }

  Future<void> _handleTrackChanged(int index, List<Track> tracks) async {
    setState(() {
      _currentTrackArtistImageUrl = null;
      _currentTrackIndex = index;
    });
  }

  void _onEditOrAddPressed(Track currentTrack) {
    EditStoryPage.show(context,
        track: currentTrack,
        originalStoryText: storyText,
        onStoryTextEdited: (newValue) => setState(() => storyText = newValue));
  }

  String _artistNames(List<Artist> artists) {
    return artists.map((artist) => artist.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureTracks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tracks = snapshot.data;
            final currentTrack =
                tracks.length != 0 ? tracks[_currentTrackIndex] : null;
            _debouncer.run(() => _loadArtistImage(currentTrack));

            return Stack(
              children: [
                Image.network(
                  currentTrack.albumImageUrl,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.7)),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35.0, sigmaY: 35.0),
                  child: Scaffold(
                    extendBodyBehindAppBar: true,
                    backgroundColor: Colors.transparent,
                    appBar: _buildAppBar(context),
                    body: _buildContent(tracks, currentTrack),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: _buildAppBar(context),
              body: Center(
                child: StatusIndicator(
                  message: 'Failed to load tracks',
                  status: Status.error,
                ),
              ),
            );
          } else {
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: _buildAppBar(context),
              body: Center(
                child: StatusIndicator(
                  message: 'Loading Tracks',
                  status: Status.loading,
                ),
              ),
            );
          }
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.playlist.name,
        style: TextStyles.appBarTitle.copyWith(letterSpacing: 0),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: CustomFlatIconButton(
          icon: Icon(
            Icons.menu,
            color: TextStyles.appBarTitle.color,
          ),
          onPressed: () => OverlayMenu.show(context,
              menuBody: MainMenuBody(
                auth: context.read<SpotifyAuth>(),
              ))),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'MORE',
            style: TextStyles.smallButtonText,
          ),
          onPressed: () => OverlayMenu.show(context,
              menuBody: MoreInfoMenuBody(
                playlist: widget.playlist,
              )),
        ),
      ],
    );
  }

  Widget _buildContent(List<Track> tracks, Track currentTrack) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, bottom: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: _buildTrackInfo(currentTrack),
            ),
          ),
          Column(children: [
            Column(children: [
              SizedBox(
                height: 8.0,
              ),
              CustomRoundedButton(
                size: ButtonSize.small,
                buttonText: storyText == '' ? 'ADD A STORY' : 'EDIT YOUR STORY',
                onPressed: () => _onEditOrAddPressed(currentTrack),
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
                  onPageChanged: (index, _) =>
                      _handleTrackChanged(index, tracks),
                ),
                PlayerProgressBar(
                  totalValue: 360,
                  initialValue: 270,
                  size: 72.0,
                ),
              ],
            )
          ])
        ],
      ),
    );
  }

  Column _buildTrackInfo(Track currentTrack) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 48.0,
        ),
        CircleAvatar(
            radius: 54.0,
            backgroundColor: Colors.transparent,
            backgroundImage: _currentTrackArtistImageUrl != null
                ? CachedNetworkImageProvider(_currentTrackArtistImageUrl)
                : null),
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
