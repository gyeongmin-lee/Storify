import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/playlists_page.dart';
import 'package:storify/models/track.dart';
import 'package:storify/models/user.dart';
import 'package:storify/services/api_path.dart';
import 'package:storify/services/spotify_interceptor.dart';
import 'package:storify/constants/values.dart' as Constants;

typedef NestedApiPathBuilder<T> = String Function(T listItem);

class SpotifyApi {
  static Client client = HttpClientWithInterceptor.build(interceptors: [
    SpotifyInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  static Future<User> getCurrentUser() async {
    final response = await client.get(
      APIPath.getCurrentUser,
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }

  static Future<User> getUserById(String userId) async {
    final response = await client.get(
      APIPath.getUserById(userId),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }

  static Future<PlayListsPage> getListOfPlaylists(
      {int limit = 20, int offset = 0}) async {
    final response =
        await client.get(APIPath.getListOfPlaylists(offset, limit));

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];
      items = await _expandNestedParam(
          originalList: items,
          nestedApiPathBuilder: (item) =>
              APIPath.getUserById(item['owner']['id']),
          paramToExpand: 'owner');

      final List<Playlist> playlists =
          items.map((item) => Playlist.fromJson(item)).toList();
      final int totalLength = json.decode(response.body)['total'];
      return PlayListsPage(playlists: playlists, totalLength: totalLength);
    } else {
      throw Exception(
          'Failed to get list of playlists with status code ${response.statusCode}');
    }
  }

  static Future<List<Track>> getTracks(String playlistId) async {
    final response = await client.get(APIPath.getTracks(playlistId));

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];
      return items.map((item) => Track.fromJson(item['track'])).toList();
    } else {
      throw Exception(
          'Failed to get tracks. with status code ${response.statusCode}');
    }
  }

  static Future<String> getArtistImageUrl(String href) async {
    final response = await client.get(href);

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

  static Future _expandNestedParam(
      {@required List originalList,
      @required NestedApiPathBuilder nestedApiPathBuilder,
      @required String paramToExpand}) async {
    return Future.wait(originalList
        .map((item) => client.get(nestedApiPathBuilder(item)).then((response) {
              item[paramToExpand] = json.decode(response.body);
              return item;
            })));
  }
}
