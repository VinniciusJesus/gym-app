import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/data/models/user_model.dart';

class UserRemote {
  final FirebaseFirestore firestore;
  UserRemote(this.firestore);

  Future<void> updateUser({
    required UserModel user,
    bool? notifications,
    bool? weeklySummary,
  }) async {
    final data = user.toMap();
    if (notifications != null) data['notifications'] = notifications;
    if (weeklySummary != null) data['weeklySummary'] = weeklySummary;
    await firestore
        .collection('users')
        .doc(user.id)
        .set(data, SetOptions(merge: true));
  }
}
