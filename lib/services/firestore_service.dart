import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> addDataToArray(
      {required String path,
      required String key,
      required dynamic data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    reference.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        await reference.update({
          key: FieldValue.arrayUnion([data]),
        });
      } else {
        await reference.set({
          key: [data],
        });
      }
    });
  }

  Future<void> removeDataFromArray(
      {required String path,
      required String key,
      required dynamic data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    reference.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        await reference.update({
          key: FieldValue.arrayRemove([data]),
        });
      } else {
        await reference.set({
          key: [data],
        });
      }
    });
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query)?,
    int sort(T lhs, T rhs)?,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final List<T> result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((element) => element != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic>? data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>?, snapshot.id));
  }

  Future<T> documentData<T>({
    required String path,
    required T builder(Map<String, dynamic>? data),
  }) async {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final DocumentSnapshot snapshot = await reference.get();
    return builder(snapshot.data() as Map<String, dynamic>?);
  }
}
