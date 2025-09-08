import 'package:flutter/material.dart';

import '../../../../core/app_state.dart';
import '../../../auth/data/datasources/auth_service.dart';
import '../../../auth/data/datasources/firestore_user_store.dart';

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
