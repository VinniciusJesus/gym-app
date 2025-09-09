import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/features/auth/data/datasources/local_user_store.dart';

import '../../../../main.dart';
import '../errors/sign_in_error_map.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseAnalytics _analytics;
  final errorsSigin = SignInErrorMapper();
  final errorsSignup = SignInErrorMapper();

  AuthService(this._auth, this._analytics);

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _analytics.logEvent(
        name: 'sign_up',
        parameters: {
          'method': 'email',
          if (userCredential.user?.uid != null)
            'user_id': userCredential.user!.uid,
        },
      );

      return userCredential;
    } catch (e) {
      errorsSignup.show(e);
      return null;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _analytics.logEvent(
        name: 'login',
        parameters: {
          'method': 'email',
          if (userCredential.user?.uid != null)
            'user_id': userCredential.user!.uid,
        },
      );

      return userCredential;
    } catch (e) {
      errorsSigin.show(e);
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    await _analytics.logEvent(
      name: 'reset_password',
      parameters: {'method': 'email'},
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _analytics.logEvent(name: 'logout');

    await LocalUserStore().clear();

    if (navigatorKey.currentContext!.mounted) {
      navigatorKey.currentContext!.go('/login');
    }
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
