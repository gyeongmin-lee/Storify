import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/my_playlists_page/playlist_item.dart';
import 'package:storify/widgets/player_page/player_page.dart';

class MyPlaylistsPage extends StatefulWidget {
  static const routeName = '/my_playlists_bloc_based';

  @override
  _MyPlaylistsPageState createState() => _MyPlaylistsPageState();
}

class _MyPlaylistsPageState extends State<MyPlaylistsPage> {
  ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyPlaylistsBloc _myPlaylistsBloc;

  @override
  void initState() {
    super.initState();
    _myPlaylistsBloc = BlocProvider.of<MyPlaylistsBloc>(context);
    _controller.addListener(_onScrolledToEnd);
  }

  void _onScrolledToEnd() {
    var isEnd = _controller.offset == _controller.position.maxScrollExtent;
    if (isEnd) _myPlaylistsBloc.add(MyPlaylistsFetched());
  }

  Future<void> _onRefresh() async {
    _myPlaylistsBloc.add(MyPlaylistsRefreshed());
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
    return BlocBuilder<MyPlaylistsBloc, MyPlaylistsState>(
      builder: (context, state) {
        if (state is MyPlaylistsInitial) {
          return StatusIndicator(status: Status.loading, message: 'LOADING');
        }
        if (state is MyPlaylistsFailure) {
          return StatusIndicator(
            status: Status.error,
            message: 'Failed to fetch playlists',
          );
        }
        if (state is MyPlaylistsWithData) {
          final playlists = state.playlists;
          final isEmpty = playlists.length == 0;
          return BlocListener<MyPlaylistsBloc, MyPlaylistsState>(
            listenWhen: (previous, current) =>
                previous is MyPlaylistsRefreshing,
            listener: (context, state) {
              if (state is MyPlaylistsSuccess) {
                _refreshController.refreshCompleted();
              }
            },
            child: SmartRefresher(
              enablePullDown: true,
              header: ClassicHeader(
                idleText: 'Pull down to refresh',
                refreshingIcon: SizedBox(
                  height: 25,
                  width: 25,
                  child: SpinKitFadingCube(
                      size: 16, color: CustomColors.secondaryTextColor),
                ),
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: isEmpty
                  ? StatusIndicator(
                      status: Status.warning,
                      message:
                          'No playlist found on your Spotify\nCreate a playlist to add stories!')
                  : ListView.separated(
                      controller: _controller,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        return PlayListItem(
                            title: playlist.name,
                            subtitle: '${playlist.numOfTracks} TRACKS',
                            imageUrl: playlist.playlistImageUrl,
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerPage.create(
                                          playlist: playlist)),
                                ));
                      },
                      itemCount: playlists.length,
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white10,
                            thickness: 1.0,
                            height: 1.0,
                          )),
            ),
          );
        }
        return Container();
      },
    );
  }
}
