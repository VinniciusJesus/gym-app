import 'package:firebase_auth/firebase_auth.dart';

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
          return error.message ?? 'Erro ao cadastrar';
      }
    }
    return 'Erro ao cadastrar';
  }
}
