import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/main.dart';

import '../../../../../core/app_state.dart';
import '../../data/datasources/auth_service.dart';
import '../../data/datasources/firestore_user_store.dart';
import '../../data/errors/sign_in_error_map.dart';
import '../../data/models/user_model.dart';
import '../ui/reset_passwod_dialog.dart';

class SignInController extends ChangeNotifier {
  final AppState app;
  final AuthService auth;
  final FirestoreUserStore remote;

  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passEC = TextEditingController();

  bool obscure = true;
  bool loading = false;
  String? error;

  SignInController({
    required this.app,
    required this.auth,
    required this.remote,
  });

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  Future<void> onForgotPassword(AuthService authService) async {
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (_) => ResetPasswordDialog(authService: authService),
    );

    // try {
    //   await auth.resetPassword(emailEC.text.trim());
    // } catch (_) {}
  }

  Future<void> onSubmit() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await submit(email: emailEC.text.trim(), password: passEC.text);
    } catch (_) {
      error ??= 'Erro ao entrar';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> submit({required String email, required String password}) async {
    try {
      final cred = await auth.signIn(email, password);
      if (cred != null) {
        final uid = cred.user!.uid;

        UserModel? model;
        try {
          model = await remote.getById(uid);
        } catch (_) {}

        model ??= UserModel.basic(
          id: uid,
          name: cred.user!.displayName ?? '',
          email: cred.user!.email ?? email,
        );

        await app.setUser(model);

        navigatorKey.currentContext!.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      await SignInErrorMapper().show(e);
      rethrow;
    } catch (e) {
      await SignInErrorMapper().show(e);
      rethrow;
    }
  }

  @override
  void dispose() {
    emailEC.dispose();
    passEC.dispose();
    super.dispose();
  }
}
