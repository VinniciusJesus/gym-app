import 'package:flutter/material.dart';
import 'package:gym/core/app_state.dart';
import 'package:gym/core/shared/theme/app_colors.dart';
import 'package:gym/core/shared/ui/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/shared/ui/auth_input.dart';
import '../../../auth/data/datasources/auth_service.dart';
import '../../../auth/data/datasources/firestore_user_store.dart';

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
                    _Card(
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
                    _Card(
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
                    _Card(
                      title: 'Preferências',
                      child: Column(
                        children: [
                          _SwitchTile(
                            title: 'Notificações',
                            subtitle: 'Receber avisos e lembretes',
                            value: notifications,
                            onChanged: (v) => setState(() => notifications = v),
                          ),
                          const Divider(height: 1),
                          _SwitchTile(
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

class _Card extends StatelessWidget {
  final String? title;
  final Widget child;
  const _Card({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSub),
      ),
      trailing: Switch.adaptive(value: value, onChanged: onChanged),
    );
  }
}

class ProfileController extends ChangeNotifier {
  final AppState app;
  final AuthService auth;
  final FirestoreUserStore remote;

  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final phoneEC = TextEditingController();
  final birthEC = TextEditingController();

  String? avatarUrl;
  bool notifications = true;
  bool weeklySummary = true;
  bool darkMode = false;

  bool loading = false;
  bool saving = false;

  ProfileController({
    required this.app,
    required this.auth,
    required this.remote,
  });

  Future<void> init() async {
    loading = true;
    notifyListeners();
    final u = app.currentUser;
    if (u != null) {
      nameEC.text = u.name ?? '';
      // emailEC.text = u.email ?? '';
      // phoneEC.text = u.phone ?? '';
      // birthEC.text = u.birth ?? '';
      // avatarUrl = u.avatarUrl;
      // notifications = u.notifications ?? true;
      // weeklySummary = u.weeklySummary ?? true;
    }
    loading = false;
    notifyListeners();
  }

  void setNotifications(bool v) {
    notifications = v;
    notifyListeners();
  }

  void setWeeklySummary(bool v) {
    weeklySummary = v;
    notifyListeners();
  }

  void setDarkMode(bool v) {
    darkMode = v;
    // app.setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
    notifyListeners();
  }

  Future<void> onChangeAvatar() async {
    // final url = await remote.pickAndUploadAvatar();
    // if (url != null) {
    //   avatarUrl = url;
    //   notifyListeners();
    // }
  }

  Future<void> onChangePassword() async {
    // await auth.sendPasswordReset(emailEC.text);
  }

  Future<void> onManageSessions() async {
    // await auth.refreshTokensEverywhere();
  }

  Future<void> onDeleteAccount() async {
    // await remote.requestAccountDeletion();
  }

  Future<void> onSignOut() async {
    await auth.signOut();
  }

  Future<void> onSave() async {
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return;
    saving = true;
    notifyListeners();
    // await remote.updateUser({
    //   'name': nameEC.text.trim(),
    //   'email': emailEC.text.trim(),
    //   'phone': phoneEC.text.trim(),
    //   'birth': birthEC.text.trim(),
    //   'avatarUrl': avatarUrl,
    //   'notifications': notifications,
    //   'weeklySummary': weeklySummary,
    // });
    saving = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    phoneEC.dispose();
    birthEC.dispose();
    super.dispose();
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const _Header({required this.title, required this.subtitle, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: AppColors.textSub)),
      ],
    );
  }
}

class _AvatarCard extends StatelessWidget {
  final String name;
  final String? image;
  final VoidCallback onChangePhoto;
  const _AvatarCard({
    required this.name,
    required this.image,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: image != null ? NetworkImage(image!) : null,
                  child:
                      image == null ? const Icon(Icons.person, size: 34) : null,
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Material(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      onTap: onChangePhoto,
                      borderRadius: BorderRadius.circular(18),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Toque para alterar sua foto',
                    style: TextStyle(color: AppColors.textSub, fontSize: 13),
                  ),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: onChangePhoto,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Trocar foto'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF4F6F8),
                foregroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SettingSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSub),
      ),
      trailing: Switch.adaptive(value: value, onChanged: onChanged),
    );
  }
}

class _SettingActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _SettingActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryDark),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSub),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _DangerCard extends StatelessWidget {
  final VoidCallback onDelete;
  const _DangerCard({required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Zona de risco',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onDelete,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                foregroundColor: const Color(0xFFD32F2F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Excluir conta permanentemente'),
            ),
          ],
        ),
      ),
    );
  }
}
