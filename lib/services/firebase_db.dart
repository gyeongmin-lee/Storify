import 'package:flutter/foundation.dart';
import 'package:storify/services/api_path.dart';
import 'package:storify/services/firestore_service.dart';

class FirebaseDatabase {
  final _service = FirestoreService.instance;

  Future<void> setStory(
          String storyText, String playlistId, String trackId) async =>
      await _service.setData(
          path: APIPath.story(playlistId, trackId), data: {'text': storyText});

  Stream<String> storyStream(
          {@required String playlistId, @required String trackId}) =>
      _service.documentStream(
          path: APIPath.story(playlistId, trackId),
          builder: (data, _) => (data['text'] as String));
}
