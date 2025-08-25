import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/firestore_user_store.dart';
import '../datasources/local_user_store.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final LocalUserStore _local;
  final FirestoreUserStore _remote;

  AuthRepository({
    FirebaseAuth? auth,
    LocalUserStore? local,
    FirestoreUserStore? remote,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _local = local ?? LocalUserStore(),
       _remote = remote ?? FirestoreUserStore();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final user = UserModel.basic(id: uid, name: name, email: email);
    await _remote.upsert(user);
    await _local.save(user);
    return user;
  }

  Future<UserModel?> currentLocalUser() => _local.read();

  Future<void> signOut() async {
    await _auth.signOut();
    await _local.clear();
  }
}
