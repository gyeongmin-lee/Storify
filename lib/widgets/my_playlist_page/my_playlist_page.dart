import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/my_playlist_page/playlist_item.dart';
import 'package:storify/widgets/player_page/player_page.dart';

class MyPlaylistPage extends StatefulWidget {
  static const routeName = '/my_playlist';

  @override
  _MyPlaylistPageState createState() => _MyPlaylistPageState();
}

class _MyPlaylistPageState extends State<MyPlaylistPage> {
  Future<List<Playlist>> _futurePlaylists;
  List<Playlist> _playlists = [];
  int _offset = 0, _limit = Constants.playlistsLimit;
  int _totalLength;
  ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd && _totalLength != null && _offset < _totalLength)
        setState(() {
          _futurePlaylists = loadPlaylists();
        });
    });
    _futurePlaylists = loadPlaylists();
  }

  Future<List<Playlist>> loadPlaylists() async {
    final nextPage =
        await SpotifyApi.getListOfPlaylists(limit: _limit, offset: _offset);
    if (_totalLength == null) _totalLength = nextPage.totalLength;

    _playlists.addAll(nextPage.playlists);
    _offset += _limit;
    return _playlists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          'MY PLAYLISTS',
          style: TextStyles.appBarTitle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.white10,
            thickness: 1.0,
            height: 1.0,
          ),
        ),
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
    return FutureBuilder<List<Playlist>>(
      future: _futurePlaylists,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final playlists = snapshot.data;
          return ListView.separated(
              controller: _controller,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return PlayListItem(
                    title: playlist.name,
                    subtitle: '${playlist.numOfTracks} SONGS',
                    imageUrl: playlist.playlistImageUrl,
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlayerPage()),
                        ));
              },
              itemCount: playlists.length,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.white10,
                    thickness: 1.0,
                    height: 1.0,
                  ));
        } else if (snapshot.hasError) {
          return StatusIndicator(
            status: Status.error,
            errorMessage: 'Failed to fetch playlists',
          );
        }

        // By default, show a loading spinner.
        return StatusIndicator(status: Status.loading);
      },
    );
  }
}
