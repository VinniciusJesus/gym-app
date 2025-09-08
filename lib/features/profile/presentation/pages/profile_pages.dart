import 'package:flutter/material.dart';
import 'package:gym/core/app_state.dart';
import 'package:gym/core/shared/theme/app_colors.dart';
import 'package:gym/core/shared/ui/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/shared/ui/auth_input.dart';
import '../../../../core/shared/ui/card_widget.dart';
import '../../../../core/shared/ui/switch_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final phoneEC = TextEditingController();
  final birthEC = TextEditingController();

  String? avatarUrl;
  bool notifications = true;
  bool weeklySummary = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final u = context.read<AppState>().currentUser;
    if (u != null) {
      nameEC.text = u.name ?? '';
      emailEC.text = u.email ?? '';
      // phoneEC.text = u.phone ?? '';
      // birthEC.text = u.birth ?? '';
      // avatarUrl = u.avatarUrl;
      // notifications = u.notifications ?? true;
      // weeklySummary = u.weeklySummary ?? true;
    }
  }

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    phoneEC.dispose();
    birthEC.dispose();
    super.dispose();
  }

  Future<void> onSave() async {
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return;
    setState(() => saving = true);
    final app = context.read<AppState>();
    // final prev = app.currentUser ?? UserModel.empty();
    // final updated = prev.copyWith(
    //   name: nameEC.text.trim(),
    //   email: emailEC.text.trim(),
    //   phone: phoneEC.text.trim(),
    //   birth: birthEC.text.trim(),
    //   avatarUrl: avatarUrl,
    //   notifications: notifications,
    //   weeklySummary: weeklySummary,
    // );
    // await app.setUser(updated);
    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardWidget(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage:
                                avatarUrl != null
                                    ? NetworkImage(avatarUrl!)
                                    : null,
                            backgroundColor: const Color(0xFFEDEFF2),
                            child:
                                avatarUrl == null
                                    ? const Icon(
                                      Icons.person_outline,
                                      size: 32,
                                      color: Color(0xFF8A94A6),
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nameEC.text.isEmpty
                                      ? 'Seu nome'
                                      : nameEC.text,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  emailEC.text.isEmpty
                                      ? 'seu@email.com'
                                      : emailEC.text,
                                  style: const TextStyle(
                                    color: AppColors.textSub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              // final u = context.read<AppState>().currentUser;
                              // if (u == null) return;
                              // // final newUrl = await LocalUserStore().pickAndUploadAvatar();
                              // if (newUrl == null) return;
                              // setState(() => avatarUrl = newUrl);
                              // await context.read<AppState>().setUser(u.copyWith(avatarUrl: newUrl));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryDark,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Trocar foto'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                      title: 'Informações',
                      child: Column(
                        children: [
                          AuthInput(
                            controller: nameEC,
                            label: 'Nome',
                            hint: 'Seu nome completo',
                            validator: Validatorless.required(
                              'Informe seu nome',
                            ),
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: emailEC,
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
                            controller: phoneEC,
                            label: 'Telefone',
                            hint: '(00) 90000-0000',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: birthEC,
                            label: 'Data de nascimento',
                            hint: 'dd/mm/aaaa',
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                      title: 'Preferências',
                      child: Column(
                        children: [
                          SwitchTile(
                            title: 'Notificações',
                            subtitle: 'Receber avisos e lembretes',
                            value: notifications,
                            onChanged: (v) => setState(() => notifications = v),
                          ),
                          const Divider(height: 1),
                          SwitchTile(
                            title: 'Resumo semanal',
                            subtitle: 'Relatório com seus dados',
                            value: weeklySummary,
                            onChanged: (v) => setState(() => weeklySummary = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Salvar alterações',
                      loading: saving,
                      onPressed: saving ? null : onSave,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: context.read<AppState>().logout,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSub,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Sair da conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
