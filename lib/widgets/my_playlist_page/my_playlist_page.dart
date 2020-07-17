import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';

class MyPlaylistPage extends StatelessWidget {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'MY PLAYLISTS',
          style: kAppBarTitleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Icon(
            Icons.menu,
            color: kAppBarTitleTextStyle.color,
          ),
          onPressed: () => {},
        ),
        bottom: PreferredSize(
            child: Divider(
              color: Colors.white10,
              thickness: 1.0,
            ),
            preferredSize: Size.fromHeight(14.0)),
      ),
    );
  }
}
