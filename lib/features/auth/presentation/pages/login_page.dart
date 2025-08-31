import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/features/auth/presentation/pages/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/app_state.dart';
import '../../../../core/shared/navigation/navigation.dart';
import '../../../../core/shared/ui/auth_input.dart';
import '../../../../core/shared/ui/primary_button.dart';
import '../../data/datasources/auth_service.dart';
import '../../data/datasources/firestore_user_store.dart';
import '../controllers/sign_in_controller.dart';
import '../ui/auth_footer_row.dart';
import '../ui/auth_header.dart';
import '../ui/or_divider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (ctx) => SignInController(
            app: ctx.read<AppState>(),
            auth: AuthService(
              FirebaseAuth.instance,
              FirebaseAnalytics.instance,
            ),
            remote: FirestoreUserStore(),
          ),
      child: Consumer<SignInController>(
        builder: (_, ctrl, __) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F8),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthHeader(
                          title: 'Bem-vindo de volta',
                          subtitle: 'Entre para continuar seus treinos.',
                        ),
                        const SizedBox(height: 18),
                        Form(
                          key: ctrl.formKey,
                          child: Column(
                            children: [
                              AuthInput(
                                controller: ctrl.emailEC,
                                label: 'Email',
                                hint: 'voce@email.com',
                                keyboardType: TextInputType.emailAddress,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Informe o email'),
                                  Validatorless.email('Email inválido'),
                                ]),
                              ),
                              const SizedBox(height: 10),
                              AuthInput(
                                controller: ctrl.passEC,
                                label: 'Senha',
                                hint: 'Sua senha',
                                obscure: ctrl.obscure,
                                action: TextInputAction.done,
                                suffix: IconButton(
                                  onPressed: ctrl.toggleObscure,
                                  icon: Icon(
                                    ctrl.obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                ),
                                validator: Validatorless.required(
                                  'Informe a senha',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                ctrl.loading ? null : ctrl.onForgotPassword,
                            child: const Text('Esqueci minha senha'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        PrimaryButton(
                          label: 'Entrar',
                          loading: ctrl.loading,
                          onPressed:
                              ctrl.loading
                                  ? null
                                  : () async {
                                    final ok =
                                        ctrl.formKey.currentState?.validate() ??
                                        false;
                                    if (!ok) return;
                                    await ctrl.onSubmit();
                                  },
                        ),
                        const SizedBox(height: 14),
                        const OrDivider(),
                        const SizedBox(height: 14),
                        SocialRow(),
                        const SizedBox(height: 14),
                        AuthFooterRow(
                          text: 'Não tem conta?',
                          actionLabel: 'Criar conta',
                          onTap: () {
                            Navigator.of(
                              context,
                            ).push(slideFromRight(page: SignUpPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
