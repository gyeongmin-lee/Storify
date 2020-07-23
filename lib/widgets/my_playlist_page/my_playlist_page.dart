import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/my_playlist_page/playlist_item.dart';
import 'package:storify/widgets/player_page/player_page.dart';
import 'package:provider/provider.dart';

class MyPlaylistPage extends StatelessWidget {
  final mockPlaylists = [
    Playlist(
        name: 'ROTATION',
        playlistImageUrl:
            'https://i.scdn.co/image/ab67616d0000b273ca086099c509810cb97fd227'),
    Playlist(
        name: 'Funeral',
        playlistImageUrl:
            'https://i.scdn.co/image/ab67616d0000b2737870762a58313ad6f981d664'),
    Playlist(
        name: 'Sufjan',
        playlistImageUrl:
            'https://i.scdn.co/image/ab67616d0000b273a7054529bcdd1ea5dcb852bc')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'MY PLAYLISTS',
          style: TextStyles.appBarTitle,
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
              menuBody: MainMenuBody(auth: context.read<SpotifyAuth>())),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0 || index == mockPlaylists.length + 1)
            return Container();
          final playlist = mockPlaylists[index - 1];
          return PlayListItem(
            title: playlist.name,
            subtitle: '${playlist.songs.length.toString()} SONGS',
            imageUrl: playlist.playlistImageUrl,
            onPressed: () => Navigator.pushNamed(context, PlayerPage.routeName),
          );
        },
        itemCount: mockPlaylists.length + 2,
        separatorBuilder: (context, index) => Divider(
              color: Colors.white10,
              thickness: 1.0,
              height: 1.0,
            ));
  }
}
