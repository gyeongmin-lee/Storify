import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:storify/models/user.dart';

class Playlist extends Equatable {
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

  factory Playlist.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    final name = json['name'];
    final id = json['id'];
    final externalUrl = json['external_urls']['spotify'];
    final isPublic = json['public'];
    final playlistImageUrl =
        json['images'].length != 0 ? json['images'][0]['url'] : null;
    final numOfTracks = json['tracks']['total'];
    final owner = User.fromJson(json['owner']);
    return Playlist(
        name: name,
        id: id,
        externalUrl: externalUrl,
        isPublic: isPublic,
        playlistImageUrl: playlistImageUrl,
        numOfTracks: numOfTracks,
        owner: owner);
  }

  String get deepLinkUri => 'https://storify-cd21c.web.app/?playlist_id=$id';

  @override
  List<Object> get props => [
        name,
        id,
        externalUrl,
        owner,
        isPublic,
        numOfTracks,
        playlistImageUrl,
      ];
}
