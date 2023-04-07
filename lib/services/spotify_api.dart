import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playback.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/models/user.dart';
import 'package:storify/services/api_path.dart';
import 'package:storify/services/spotify_interceptor.dart';

typedef NestedApiPathBuilder<T> = String Function(T listItem);

class PremiumRequiredException implements Exception {}

class NoActiveDeviceFoundException implements Exception {}

class SpotifyApi {
  static Client client = InterceptedClient.build(interceptors: [
    SpotifyInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  static Future<User> getCurrentUser() async {
    final response = await client.get(Uri.parse(APIPath.getCurrentUser));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }

  static Future<User> getUserById(String userId) async {
    final response = await client.get(Uri.parse(APIPath.getUserById(userId)));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }

  static Future<List<Playlist>> getListOfPlaylists(
      {int limit = 20, int offset = 0}) async {
    final response =
        await client.get(Uri.parse(APIPath.getListOfPlaylists(offset, limit)));

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];
      items = await _expandNestedParam(
          originalList: items,
          nestedApiPathBuilder: (item) =>
              APIPath.getUserById(item['owner']['id']),
          paramToExpand: 'owner');

      return items.map((item) => Playlist.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to get list of playlists with status code ${response.statusCode}');
    }
  }

  static Future<Playlist> getPlaylist(String? playlistId) async {
    final response =
        await client.get(Uri.parse(APIPath.getPlaylist(playlistId)));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final onwerResponse = await client
          .get(Uri.parse(APIPath.getUserById(responseBody['owner']['id'])));
      responseBody['owner'] = json.decode(onwerResponse.body);
      return Playlist.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to get a playlist with status code ${response.statusCode}');
    }
  }

  static Future<List<Track>> getTracks(String? playlistId) async {
    final response = await client.get(Uri.parse(APIPath.getTracks(playlistId)));

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];
      return items.map((item) => Track.fromJson(item['track'])).toList();
    } else {
      throw Exception(
          'Failed to get tracks. with status code ${response.statusCode}');
    }
  }

  static Future<String?> getArtistImageUrl(String href) async {
    final response = await client.get(Uri.parse(href));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final images = responseBody['images'];
      if (images.length == 0) return null;
      for (final image in images) {
        final imageWidth = image['width'];
        final imageHeight = image['height'];
        if (imageWidth < Constants.artistImageMaxSize ||
            imageHeight < Constants.artistImageMaxSize) {
          return image['url'];
        }
      }
      return images[0]['url'];
    } else {
      throw Exception(
          'Failed to get artist image url with status code ${response.statusCode}');
    }
  }

  static Future<void> play({
    required String? playlistId,
    required String? trackId,
    int? positionMs = 0,
  }) async {
    final response = await client.put(Uri.parse(APIPath.play),
        body: json.encode({
          'context_uri': 'spotify:playlist:$playlistId',
          'offset': {'uri': 'spotify:track:$trackId'},
          'position_ms': positionMs,
        }));

    if (response.statusCode == 204) return;
    if (response.statusCode == 403) {
      final reason = json.decode(response.body)['error']['reason'];
      if (reason == 'PREMIUM_REQUIRED ') throw PremiumRequiredException();
    }
    if (response.statusCode == 404) throw NoActiveDeviceFoundException();
  }

  static Future<void> pause() async {
    final response = await client.put(Uri.parse(APIPath.pause));
    if (response.statusCode == 204)
      try {
        final playback = await _getCurrentPlayback();
        if (!playback.isPlaying!)
          return;
        else
          throw Exception();
      } catch (_) {
        throw Exception('Failed to pause');
      }

    if (response.statusCode == 403) {
      final reason = json.decode(response.body)['error']['reason'];
      if (reason == 'PREMIUM_REQUIRED ') throw PremiumRequiredException();
    }
    if (response.statusCode == 404) throw NoActiveDeviceFoundException();
  }

  static Future<Playback> _getCurrentPlayback() async {
    final response = await client.get(Uri.parse(APIPath.player));
    if (response.statusCode == 200) {
      return Playback.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get player state with status code ${response.statusCode}');
    }
  }

  static Stream<Playback?> getCurrentPlaybackStream() async* {
    yield* Stream.periodic(Constants.playerStatePollDuration, (_) async {
      try {
        final currentPlayback = await _getCurrentPlayback();
        return currentPlayback;
      } catch (_) {
        return null;
      }
    }).asyncMap(((event) async => (await event)));
  }

  static Future _expandNestedParam(
      {required List originalList,
      required NestedApiPathBuilder nestedApiPathBuilder,
      required String paramToExpand}) async {
    return Future.wait(originalList.map((item) =>
        client.get(Uri.parse(nestedApiPathBuilder(item))).then((response) {
          item[paramToExpand] = json.decode(response.body);
          return item;
        })));
  }
}
