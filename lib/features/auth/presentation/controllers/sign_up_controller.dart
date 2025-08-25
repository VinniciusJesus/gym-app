import 'package:flutter/material.dart';

import '../../../../core/app_state.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class SignUpController extends ChangeNotifier {
  final AuthRepository repo;
  final AppState app;
  bool loading = false;
  String? error;
  UserModel? user;

  SignUpController({required this.app, AuthRepository? repository})
    : repo = repository ?? AuthRepository();

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      user = await repo.signUp(name: name, email: email, password: password);
      await app.setUser(user);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
