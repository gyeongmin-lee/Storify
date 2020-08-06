import 'package:flutter/material.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/player_page/player_page_app_bar.dart';

class PlayerPageError extends StatelessWidget {
  final Playlist playlist;

  const PlayerPageError({Key key, @required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PlayerPageAppBar(playlist: playlist),
      body: Center(
        child: StatusIndicator(
          message: 'Failed to load tracks',
          status: Status.error,
        ),
      ),
    );
  }
}
