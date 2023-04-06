import 'package:algolia/algolia.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storify/models/playlist.dart';

class AlgoliaService {
  Algolia algolia;

  AlgoliaService._() {
    this.algolia = Algolia.init(
      applicationId: 'AM3NYQWJOW',
      apiKey: DotEnv().env['API_KEY'],
    );
  }

  static final _instance = AlgoliaService._();
  factory AlgoliaService() {
    return _instance;
  }

  Future<void> updateIndexWithPlaylist(Map<String, dynamic> data) async {
    data['objectID'] = data['id'];
    await algolia.instance.index('playlists').addObject(data);
  }

  Future<List<Playlist>> getSearchResult(String queryText) async {
    AlgoliaQuery query = algolia.instance.index('playlists').query(queryText);
    query = query.facetFilter('is_public:true');
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    return snapshot.hits
        .map((hitSnapshot) => Playlist.fromFirebaseSnapshot(hitSnapshot.data))
        .toList();
  }
}
