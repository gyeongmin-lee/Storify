import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/overlay_menu/overlay_menu.dart';

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
        leading: CustomFlatIconButton(
          icon: Icon(
            Icons.menu,
            color: kAppBarTitleTextStyle.color,
          ),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
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

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => OverlayMenu(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.0, end: 1.0);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        );

        return FadeTransition(
          opacity: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
