import 'package:flutter/foundation.dart';
import 'package:storify/models/song.dart';
import 'package:storify/models/user.dart';

class Playlist {
  Playlist(
      {@required this.name,
      this.songs = const [],
      this.playlistImageUrl,
      this.spotifyLink, // TODO required
      this.creator}); // TODO required
  final String name;
  final List<Song> songs;
  final String spotifyLink;
  final User creator;
  final String playlistImageUrl;
}
