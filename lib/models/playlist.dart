import 'package:equatable/equatable.dart';
import 'package:storify/models/user.dart';

class Playlist extends Equatable {
  Playlist(
      {required this.name,
      required this.id,
      required this.isPublic,
      required this.playlistImageUrl,
      required this.numOfTracks,
      required this.externalUrl,
      required this.owner});
  final String? name;
  final String? id;
  final String? externalUrl;
  final User owner;
  final bool? isPublic;
  final int? numOfTracks;
  final String? playlistImageUrl;

  factory Playlist.fromJson(Map<String, dynamic> json) {
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

  factory Playlist.fromFirebaseSnapshot(Map<String, dynamic> json) => Playlist(
        id: json['id'],
        name: json['name'],
        externalUrl: json['external_url'],
        isPublic: json['is_public'],
        playlistImageUrl: json['playlist_image_url'],
        numOfTracks: json['num_of_tracks'],
        owner: User.fromJson(json['owner']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'external_url': externalUrl,
        'is_public': isPublic,
        'playlist_image_url': playlistImageUrl,
        'num_of_tracks': numOfTracks,
        'owner': owner.toJson(),
      };

  String get deepLinkUri => 'https://storify-cd21c.web.app/?playlist_id=$id';

  @override
  List<Object?> get props => [
        name,
        id,
        externalUrl,
        owner,
        isPublic,
        numOfTracks,
        playlistImageUrl,
      ];
}
