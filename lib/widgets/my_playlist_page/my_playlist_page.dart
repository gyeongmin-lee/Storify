import 'package:flutter/material.dart';
import 'package:storify/models/artist.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/song.dart';

class MyPlaylistPage extends StatelessWidget {
  static const routeName = '/my_playlist_page';

  final mockPlaylists = [
    Playlist(
        name: 'ROTATION',
        playlistImageUrl:
            'https://i.scdn.co/image/ab67616d0000b273ca086099c509810cb97fd227'),
    Playlist(
        name: 'The Funeral',
        playlistImageUrl:
            'https://i.scdn.co/image/ab67616d0000b2737870762a58313ad6f981d664')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY PLAYLISTS'),
        centerTitle: true,
      ),
    );
  }
}
