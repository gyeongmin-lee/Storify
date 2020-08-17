import 'package:flutter/material.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:provider/provider.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/my_playlists_page/playlist_item.dart';
import 'package:storify/widgets/player_page/player_page.dart';

class SavedPlaylistsPage extends StatefulWidget {
  @override
  _SavedPlaylistsPageState createState() => _SavedPlaylistsPageState();
}

class _SavedPlaylistsPageState extends State<SavedPlaylistsPage> {
  FirebaseDB _firebaseDB;

  @override
  void initState() {
    super.initState();
    _firebaseDB = FirebaseDB();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<SpotifyAuth>().user.id;
    return StreamBuilder<List<Playlist>>(
      stream: _firebaseDB.savedPlaylistsStream(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final playlists = snapshot.data;
          if (playlists.isEmpty) {
            return StatusIndicator(
                status: Status.warning,
                message:
                    'You do not have a saved playlist yet. \nTap \'BROWSE\' to find more playlists');
          } else {
            return ListView.separated(
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return PlayListItem(
                      title: playlist.name,
                      subtitle: '${playlist.numOfTracks} TRACKS',
                      imageUrl: playlist.playlistImageUrl,
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PlayerPage.create(playlist: playlist)),
                          ));
                },
                itemCount: playlists.length,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.white10,
                      thickness: 1.0,
                      height: 1.0,
                    ));
          }
        } else {
          return StatusIndicator(
            message: 'Loading Saved Playlists',
            status: Status.loading,
          );
        }
      },
    );
  }
}
