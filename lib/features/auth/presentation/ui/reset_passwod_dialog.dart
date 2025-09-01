// reset_password_dialog.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared/theme/app_colors.dart';
import '../../../../core/shared/ui/notice_dialog.dart';
import '../../../../core/shared/ui/primary_button.dart';
import '../../data/datasources/auth_service.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String? initialEmail;
  final AuthService authService;

  const ResetPasswordDialog({
    super.key,
    this.initialEmail,
    required this.authService,
  });

  static Future<void> open(
    BuildContext context, {
    String? email,
    required AuthService authService,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => ResetPasswordDialog(
            initialEmail: email,
            authService: authService,
          ),
    );
    if (ok == true) {
      await Dialogs.success(
        context,
        'Enviamos um link de redefinição para o seu e-mail.',
        title: 'Tudo certo',
      );
    }
  }

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  final _emailEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _emailEC.text = widget.initialEmail ?? '';
    _c = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: .98,
      end: 1,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, .02),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _c.forward();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _c.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Informe seu e-mail';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  Future<void> _submit(AuthService authService) async {
    if (_loading) return;
    setState(() => _errorText = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      await authService.resetPassword(_emailEC.text.trim());
      if (mounted) Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      final code = e.code.toLowerCase();
      String msg = 'Não foi possível enviar o e-mail de redefinição.';
      if (code.contains('user-not-found'))
        msg = 'Não encontramos uma conta com este e-mail.';
      if (code.contains('invalid-email')) msg = 'E-mail inválido.';
      if (code.contains('too-many-requests'))
        msg = 'Muitas tentativas. Tente novamente mais tarde.';
      setState(() => _errorText = msg);
    } catch (_) {
      setState(() => _errorText = 'Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SlideTransition(
          position: _slide,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Recuperar senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212529),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Informe seu e-mail para enviarmos o link de redefinição.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xFF5F6368),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailEC,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.done,
                            validator: _validateEmail,
                            onFieldSubmitted:
                                (_) => _submit(widget.authService),
                            decoration: InputDecoration(
                              hintText: 'seuemail@exemplo.com',
                              filled: true,
                              fillColor: const Color(0xFFF7F7F8),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _errorText,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  label:
                                      _loading ? 'Enviando...' : 'Enviar link',
                                  height: 42,
                                  onPressed: () {
                                    _loading
                                        ? null
                                        : _submit(widget.authService);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed:
                                _loading
                                    ? null
                                    : () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -26,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
