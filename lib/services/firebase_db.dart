import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/algolia_service.dart';
import 'package:storify/services/api_path.dart';
import 'package:storify/services/firestore_service.dart';
import 'package:storify/constants/values.dart' as Constants;

class FirebaseDB {
  final _service = FirestoreService.instance;
  final _angoliaService = AlgoliaService();

  Future<void> setStory(
      String storyText, Playlist playlist, String trackId) async {
    await _service.setData(
        path: APIPath.story(playlist.id, trackId), data: {'text': storyText});
    await _service.setData(
      path: APIPath.playlist(playlist.id),
      data: {
        'playlist_data': playlist.toJson(),
        'timestamp': FieldValue.serverTimestamp()
      },
    );
    await _angoliaService.updateIndexWithPlaylist(playlist.toJson());
  }

  Stream<String> storyStream(
          {@required String playlistId, @required String trackId}) =>
      _service.documentStream(
          path: APIPath.story(playlistId, trackId),
          builder: (data, _) => data != null ? (data['text'] as String) : '');

  Stream<List<Playlist>> playlistsStream() => _service.collectionStream(
        path: APIPath.playlists,
        builder: (data, documentID) =>
            Playlist.fromFirebaseSnapshot(data['playlist_data']),
        queryBuilder: (query) => query
            .orderBy('timestamp', descending: true)
            .limit(Constants.recentlyUpdatedPlaylistsLimit),
      );

  Stream<bool> isPlaylistSavedStream(
          {@required String userId, @required String playlistId}) =>
      _service.documentStream(
        path: APIPath.savedPlaylist(userId: userId, playlistId: playlistId),
        builder: (data, _) => data != null,
      );

  Stream<List<Playlist>> savedPlaylistsStream({@required String userId}) =>
      _service.collectionStream(
        path: APIPath.savedPlaylists(userId: userId),
        builder: (data, documentID) =>
            Playlist.fromFirebaseSnapshot(data['playlist_data']),
      );

  Future<void> savePlaylist(
      {@required String userId, @required Playlist playlist}) async {
    await _service.setData(
        path: APIPath.savedPlaylist(userId: userId, playlistId: playlist.id),
        data: {
          'playlist_data': playlist.toJson(),
          'timestamp': FieldValue.serverTimestamp()
        });
  }

  Future<void> unsavePlaylist(
      {@required String userId, @required String playlistId}) async {
    await _service.deleteData(
        path: APIPath.savedPlaylist(userId: userId, playlistId: playlistId));
  }
}
