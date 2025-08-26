import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/app_state.dart';
import '../../../../core/shared/ui/auth_input.dart';
import '../../../../core/shared/ui/primary_button.dart';
import '../../data/datasources/auth_service.dart';
import '../../data/datasources/firestore_user_store.dart';
import '../controllers/sign_up_controller.dart';
import '../ui/auth_footer_row.dart';
import '../ui/auth_header.dart';
import '../ui/or_divider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (ctx) => SignUpController(
            app: ctx.read<AppState>(),
            auth: AuthService(FirebaseAuth.instance),
            remote: FirestoreUserStore(),
          ),
      child: Consumer<SignUpController>(
        builder: (_, ctrl, __) {
          return Scaffold(
            backgroundColor: Color(0xFFF4F6F8),
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
                          title: 'Crie sua conta',
                          subtitle:
                              'Experiência simples e agradável para seus treinos.',
                        ),
                        const SizedBox(height: 18),
                        Form(
                          key: ctrl.formKey,
                          child: Column(
                            children: [
                              AuthInput(
                                controller: ctrl.nameEC,
                                label: 'Nome completo',
                                hint: 'Seu nome',
                                validator: Validatorless.required(
                                  'Informe seu nome',
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                hint: 'Mínimo 6 caracteres',
                                obscure: ctrl.obscure,
                                action: TextInputAction.next,
                                suffix: IconButton(
                                  onPressed: ctrl.toggleObscure,
                                  icon: Icon(
                                    ctrl.obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Informe a senha'),
                                  Validatorless.min(6, 'Mínimo 6 caracteres'),
                                ]),
                              ),
                              const SizedBox(height: 10),
                              AuthInput(
                                controller: ctrl.confirmEC,
                                label: 'Confirmar senha',
                                hint: 'Repita a senha',
                                obscure: ctrl.obscureConfirm,
                                action: TextInputAction.done,
                                suffix: IconButton(
                                  onPressed: ctrl.toggleObscureConfirm,
                                  icon: Icon(
                                    ctrl.obscureConfirm
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Confirme a senha'),
                                  Validatorless.compare(
                                    ctrl.passEC,
                                    'As senhas não conferem',
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        PrimaryButton(
                          label: 'Cadastrar',
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
                                    // Sem SnackBar aqui. Fluxo pós-submit fica a cargo do caller/navegação.
                                  },
                        ),
                        const SizedBox(height: 14),
                        const OrDivider(),
                        const SizedBox(height: 14),
                        SocialRow(),
                        const SizedBox(height: 14),

                        AuthFooterRow(
                          text: 'Já tem conta?',
                          actionLabel: 'Entrar',
                          onTap: () {},
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
