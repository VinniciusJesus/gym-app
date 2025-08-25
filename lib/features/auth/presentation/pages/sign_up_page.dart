import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_state.dart';
import '../controllers/sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passEC = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    const bg = Color(0xFFF4F6F8);
    const primary = Color(0xFFB784B7);
    const primaryDark = Color(0xFF8E7AB5);
    const peach = Color(0xFFF7C7A3);
    const textMain = Color(0xFF1D1D1F);
    const textSub = Color(0xFF6B7280);

    final inputTheme = InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textSub, fontSize: 13),
      labelStyle: const TextStyle(color: textSub, fontSize: 12.5),
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: bg,
        inputDecorationTheme: inputTheme,
        textSelectionTheme: const TextSelectionThemeData(cursorColor: primary),
        colorScheme: Theme.of(context).colorScheme.copyWith(primary: primary),
      ),
      child: ChangeNotifierProvider(
        create: (_) => SignUpController(app: context.read<AppState>()),
        child: Consumer<SignUpController>(
          builder: (_, ctrl, __) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (app.currentUser == null) ...[
                            const Text(
                              'Crie sua conta',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textMain,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Experiência simples e agradável para seus treinos.',
                              style: TextStyle(fontSize: 13, color: textSub),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              controller: nameEC,
                              decoration: const InputDecoration(
                                labelText: 'Nome completo',
                                hintText: 'Seu nome',
                              ),
                              style: const TextStyle(fontSize: 14.5),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailEC,
                              decoration: const InputDecoration(
                                labelText: 'Telefone/Email',
                                hintText: 'Telefone/Email',
                              ),
                              style: const TextStyle(fontSize: 14.5),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: passEC,
                              obscureText: obscure,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                hintText: 'Mínimo 6 caracteres',
                                suffixIcon: IconButton(
                                  onPressed:
                                      () => setState(() => obscure = !obscure),
                                  icon: Icon(
                                    obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14.5),
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              style: buttonStyle,
                              onPressed:
                                  ctrl.loading
                                      ? null
                                      : () async {
                                        await ctrl.submit(
                                          name: nameEC.text.trim(),
                                          email: emailEC.text.trim(),
                                          password: passEC.text,
                                        );
                                        if (!mounted) return;
                                        if (ctrl.error == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cadastro concluído',
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                ctrl.error ?? 'Erro',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                              child:
                                  ctrl.loading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text('Cadastrar'),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0x11000000),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'ou',
                                  style: TextStyle(
                                    color: textSub,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0x11000000),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _SocialDot(icon: Icons.apple),
                                SizedBox(width: 12),
                                _SocialDot(icon: Icons.g_mobiledata),
                                SizedBox(width: 12),
                                _SocialDot(icon: Icons.facebook_rounded),
                              ],
                            ),
                            const SizedBox(height: 14),

                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Já tem conta?',
                                    style: TextStyle(
                                      color: textSub,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryDark,
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      textStyle: const TextStyle(
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    child: const Text('Entrar'),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Bem‑vindo',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textMain,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              app.currentUser!.name,
                              style: const TextStyle(
                                fontSize: 14.5,
                                color: textSub,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: peach.withOpacity(.22),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text(
                                'Sua conta foi configurada com sucesso.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textMain, fontSize: 14),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SocialDot extends StatelessWidget {
  final IconData icon;
  const _SocialDot({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Color(0xFF1D1D1F), size: 20),
    );
  }
}
