import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/user_model.dart';

class FirestoreUserStore {
  final _col = FirebaseFirestore.instance.collection('users');

  Future<void> upsert(UserModel user) async {
    await _col.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!..['id'] = doc.id;
    return UserModel.fromMap(data);
  }
}
