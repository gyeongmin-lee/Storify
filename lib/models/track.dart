import 'package:flutter/foundation.dart';
import 'package:storify/models/artist.dart';

class Track {
  Track(
      {@required this.name,
      @required this.artist,
      @required this.albumImageUrl,
      this.songStory});
  final String name;
  final Artist artist;
  final String albumImageUrl;
  final String songStory;
}
