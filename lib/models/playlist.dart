import 'package:flutter/foundation.dart';
import 'package:storify/models/track.dart';
import 'package:storify/models/user.dart';

class Playlist {
  Playlist(
      {@required this.name,
      @required this.id,
      @required this.isPublic,
      @required this.playlistImageUrl,
      @required this.numOfTracks,
      @required this.externalUrl,
      @required this.owner});
  final String name;
  final String id;
  final String externalUrl;
  final User owner;
  final bool isPublic;
  final int numOfTracks;
  final String playlistImageUrl;

  Playlist.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        externalUrl = json['external_urls']['spotify'],
        isPublic = json['public'],
        playlistImageUrl = json['images'][0]['url'],
        numOfTracks = json['tracks']['total'],
        owner = User.fromJson(json['owner']);
}
