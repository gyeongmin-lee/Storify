import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:storify/models/artist.dart';

class Track extends Equatable {
  Track({
    @required this.name,
    @required this.id,
    @required this.artists,
    @required this.albumImageUrl,
    @required this.durationMs,
  });
  final String name;
  final String id;
  final List<Artist> artists;
  final String albumImageUrl;
  final int durationMs;

  factory Track.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final id = json['id'];
    final List<Artist> artists = (json['artists'] as List)
        .map((artist) => Artist.fromJson(artist))
        .toList();
    final images = json['album']['images'];
    final albumImageUrl = images.length > 1
        ? images[1]['url']
        : images.length > 0 ? images[0]['url'] : null;
    final durationMs = json['duration_ms'];
    return Track(
        name: name,
        id: id,
        artists: artists,
        albumImageUrl: albumImageUrl,
        durationMs: durationMs);
  }

  @override
  List<Object> get props => [name, id, artists, albumImageUrl, durationMs];
}
