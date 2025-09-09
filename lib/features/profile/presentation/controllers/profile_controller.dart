import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym/features/profile/data/datasources/user_remote.dart';
import 'package:gym/main.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_state.dart';
import '../../../auth/data/datasources/auth_service.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileController extends ChangeNotifier {
  final AuthService auth;
  final remote = UserRemote(FirebaseFirestore.instance);

  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final phoneEC = TextEditingController();
  final birthEC = TextEditingController();
  final weightEC = TextEditingController();
  final heightEC = TextEditingController();

  String? avatarUrl;
  bool notifications = true;
  bool weeklySummary = true;
  bool darkMode = false;

  bool loading = false;
  bool saving = false;

  ProfileController({required this.auth});

  Future<void> init() async {
    loading = true;
    notifyListeners();
    final u = navigatorKey.currentContext!.read<AppState>().currentUser;
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

  DateTime? _parseBirth(String input) {
    final s = input.trim();
    if (s.isEmpty) return null;
    final p = s.split('/');
    if (p.length != 3) return null;
    final d = int.tryParse(p[0]);
    final m = int.tryParse(p[1]);
    final y = int.tryParse(p[2]);
    if (d == null || m == null || y == null) return null;
    try {
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  double? _parseNum(String input) {
    final s = input.trim().replaceAll(',', '.');
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  Future<void> onSave() async {
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return;
    saving = true;
    notifyListeners();

    final u = navigatorKey.currentContext!.read<AppState>().currentUser;
    if (u == null) {
      saving = false;
      notifyListeners();
      return;
    }

    final updated = UserModel(
      id: u.id,
      name: nameEC.text.trim(),
      email: emailEC.text.trim(),
      createdAt: u.createdAt,
      birthDate: _parseBirth(birthEC.text),
      weight: _parseNum(weightEC.text),
      height: _parseNum(heightEC.text),
    );

    await remote.updateUser(
      user: updated,
      notifications: notifications,
      weeklySummary: weeklySummary,
    );

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
