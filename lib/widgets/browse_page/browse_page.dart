import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/playlist_item/playlist_item.dart';
import 'package:storify/widgets/player_page/player_page.dart';
import 'package:storify/widgets/search_playlists_page.dart/search_playlists_page.dart';

class BrowsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 128.0),
        child: Column(
          children: [
            Text('Browse',
                style: TextStyles.primary.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    letterSpacing: -2.0)),
            SizedBox(
              height: 16.0,
            ),
            _buildSearchBox(context),
            SizedBox(
              height: 24.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Text(
                  'Recently Updated',
                  textAlign: TextAlign.left,
                  style: TextStyles.primary
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            Divider(
              color: Colors.white10,
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder<List<Playlist>>(
              stream: FirebaseDB().playlistsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final playlists = snapshot.data;
                  if (playlists == null || playlists.isEmpty) {
                    return Container();
                  }

                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 0.0),
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        return PlayListItem(
                            subtitleText: 'By ${playlist.owner.name}',
                            playlist: playlist,
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
                          ));
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 128.0),
                    child: StatusIndicator(
                      message: 'Loading Saved Playlists',
                      status: Status.loading,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchPlaylistsPage(),
      )),
      child: Container(
        alignment: Alignment.center,
        height: 48.0,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.white38,
              size: 22.0,
            ),
            SizedBox(
              width: 6.0,
            ),
            Text(
              "Search for playlists",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white38,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
