import 'package:flutter/material.dart';

import '../../../../../core/app_state.dart';

class SignUpController extends ChangeNotifier {
  final AppState app;

  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passEC = TextEditingController();
  final confirmEC = TextEditingController();

  bool obscure = true;
  bool obscureConfirm = true;
  bool loading = false;
  String? error;

  SignUpController({required this.app});

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
      // defina navegação/efeitos fora da view (ex.: callback do router).
    } catch (_) {
      error = 'Erro ao cadastrar';
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
    // integração real; defina error = 'mensagem' em caso de falha
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
