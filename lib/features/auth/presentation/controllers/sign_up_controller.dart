import 'package:flutter/material.dart';
import 'package:gym/main.dart';

import '../../../../../core/app_state.dart';
import '../../../../core/shared/navigation/navigation.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../data/datasources/auth_service.dart';
import '../../data/datasources/firestore_user_store.dart';
import '../../data/models/user_model.dart';

class SignUpController extends ChangeNotifier {
  final AppState app;
  final AuthService auth;
  final FirestoreUserStore remote;

  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passEC = TextEditingController();
  final confirmEC = TextEditingController();

  bool obscure = true;
  bool obscureConfirm = true;
  bool loading = false;
  String? error;

  SignUpController({
    required this.app,
    required this.auth,
    required this.remote,
  });

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void toggleObscureConfirm() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await submit(
        name: nameEC.text.trim(),
        email: emailEC.text.trim(),
        password: passEC.text,
      );
    } catch (_) {
      error ??= 'Erro ao cadastrar';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await auth.signUp(email, password);
      if (cred != null) {
        final model = UserModel.basic(
          id: cred.user!.uid,
          name: name,
          email: email,
        );

        await remote.upsert(model);
        await app.setUser(model);

        Navigator.of(
          navigatorKey.currentContext!,
        ).push(slideFromRight(page: HomePage()));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passEC.dispose();
    confirmEC.dispose();
    super.dispose();
  }
}
