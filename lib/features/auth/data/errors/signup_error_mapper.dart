import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/main.dart' show navigatorKey, scaffoldMessengerKey;

import '../../../../core/shared/ui/notice_dialog.dart';

enum ErrorUi { snack, dialog }

class SignUpErrorMapper {
  const SignUpErrorMapper();

  String map(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'E-mail inválido';
        case 'weak-password':
          return 'Senha fraca';
        case 'email-already-in-use':
          return 'E-mail já em uso';
        case 'operation-not-allowed':
          return 'Cadastro desativado';
        case 'network-request-failed':
          return 'Falha de rede';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente mais tarde';
        case 'missing-password':
          return 'Informe a senha';
        default:
          return 'Erro ao cadastrar';
      }
    }
    return 'Erro ao cadastrar';
  }

  ErrorUi ui(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
        case 'weak-password':
        case 'missing-password':
        case 'network-request-failed':
          return ErrorUi.snack;
        default:
          return ErrorUi.dialog;
      }
    }
    return ErrorUi.dialog;
  }

  Future<void> show(Object error) async {
    final message = map(error);
    final kind = ui(error);

    if (kind == ErrorUi.snack) {
      final ScaffoldMessengerState? messengerA = ScaffoldMessenger.maybeOf(
        navigatorKey.currentContext!,
      );
      final ScaffoldMessengerState? messengerB =
          scaffoldMessengerKey.currentState is ScaffoldMessengerState
              ? scaffoldMessengerKey.currentState
              : null;
      final messenger = messengerA ?? messengerB;
      if (messenger != null) {
        messenger.clearSnackBars();
        messenger.showSnackBar(SnackBar(content: Text(message)));
        return;
      }
    }
    await Dialogs.error(navigatorKey.currentContext!, message);
  }
}
