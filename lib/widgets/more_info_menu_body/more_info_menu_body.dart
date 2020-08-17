import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/playlist_actions.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';

class MoreInfoMenuBody extends StatelessWidget {
  const MoreInfoMenuBody({Key key, @required this.playlist}) : super(key: key);
  final Playlist playlist;

  Future<void> _onOpenInSpotify() async {
    final url = playlist.externalUrl;
    await PlaylistActions.openInSpotify(url);
  }

  Future<void> _onShareAsLink() async {
    await PlaylistActions.shareAsLink(playlist);
  }

  Future<void> _onSavePlaylist(BuildContext context) async {
    final spotifyAuth = context.read<SpotifyAuth>();
    await PlaylistActions.savePlaylist(spotifyAuth.user.id, playlist);
  }

  Future<void> _onUnsavePlaylist(BuildContext context) async {
    final spotifyAuth = context.read<SpotifyAuth>();
    await PlaylistActions.unsavePlaylist(spotifyAuth.user.id, playlist.id);
  }

  @override
  Widget build(BuildContext context) {
    final _firebaseDB = FirebaseDB();
    final userId = context.watch<SpotifyAuth>().user.id;
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 96.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPlaylistInfo(),
          Column(
            children: <Widget>[
              CustomFlatTextButton(
                text: 'OPEN IN SPOTIFY',
                onPressed: _onOpenInSpotify,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomFlatTextButton(
                text: 'SHARE AS LINK',
                onPressed: _onShareAsLink,
              ),
              SizedBox(
                height: 16.0,
              ),
              StreamBuilder<bool>(
                stream: _firebaseDB.isPlaylistSavedStream(
                    userId: userId, playlistId: playlist.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final isPlaylistSaved = snapshot.data;
                    return CustomFlatTextButton(
                      text: isPlaylistSaved
                          ? 'REMOVE FROM SAVED'
                          : 'SAVE PLAYLIST',
                      onPressed: isPlaylistSaved
                          ? () => _onUnsavePlaylist(context)
                          : () => _onSavePlaylist(context),
                    );
                  } else {
                    return Container(
                      height: 48.0,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Column _buildPlaylistInfo() {
    return Column(
      children: <Widget>[
        CircleAvatar(
            radius: 54.0,
            backgroundColor: Colors.transparent,
            backgroundImage:
                CustomImageProvider.cachedImage(playlist.playlistImageUrl)),
        SizedBox(
          height: 16.0,
        ),
        Text(
          playlist.name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.bannerText.copyWith(letterSpacing: 0.0),
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Created by',
                style: TextStyles.light.copyWith(fontSize: 14.0)),
            SizedBox(
              width: 8.0,
            ),
            CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.transparent,
                backgroundImage: CustomImageProvider.cachedImage(
                    playlist.owner.avatarImageUrl)),
            SizedBox(
              width: 8.0,
            ),
            Text(playlist.owner.name,
                style: TextStyles.primary.copyWith(fontSize: 16.0)),
          ],
        )
      ],
    );
  }
}
