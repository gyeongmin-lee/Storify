import 'package:flutter_test/flutter_test.dart';
import 'package:storify/models/playlist.dart';

import 'user_test.dart';

void main() {
  group('fromJson', () {
    test('null', () {
      final playlist = Playlist.fromJson(null);
      expect(playlist, null);
    });

    test('with all properties', () {
      final playlist = Playlist.fromJson({
        'name': 'Playlist1',
        'id': '123',
        'external_urls': {'spotify': 'spotify_url'},
        'public': true,
        'images': [
          {'url': 'image_url'}
        ],
        'tracks': {'total': 30},
        'owner': sampleUserData,
      });
      expect(
          playlist,
          Playlist(
              name: 'Playlist1',
              id: '123',
              externalUrl: 'spotify_url',
              isPublic: true,
              playlistImageUrl: 'image_url',
              numOfTracks: 30,
              owner: sampleUser));
    });
  });
}
