import 'package:flutter/foundation.dart';
import 'package:storify/models/playlist.dart';

class PlayListsPage {
  final List<Playlist> playlists;
  final int totalLength;

  PlayListsPage({@required this.totalLength, @required this.playlists});
}
