import 'dart:async';
import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym/features/profile/data/datasources/user_remote.dart';
import 'package:gym/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_state.dart';
import '../../../../core/shared/ui/notice_dialog.dart';
import '../../../../core/shared/utils/internet_checker.dart';
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
  XFile? _pendingAvatar;

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
      nameEC.text = u.name;
      emailEC.text = u.email;
      birthEC.text =
          u.birthDate != null ? UtilData.obterDataDDMMAAAA(u.birthDate!) : '';
      weightEC.text =
          u.weight != null ? u.weight!.toString().replaceAll('.', ',') : '';
      heightEC.text =
          u.height != null ? u.height!.toString().replaceAll('.', ',') : '';
      avatarUrl = u.avatarUrl;
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

  ImageProvider? get avatarImage {
    if (_pendingAvatar != null) return FileImage(File(_pendingAvatar!.path));
    if (avatarUrl != null && avatarUrl!.isNotEmpty)
      return NetworkImage(avatarUrl!);
    return null;
  }

  Future<void> onChangeAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    _pendingAvatar = picked;
    notifyListeners();
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

  Future<String?> _uploadAvatarIfNeeded(
    String uid, {
    String? previousUrl,
  }) async {
    if (_pendingAvatar == null) return null;
    final online = await hasInternet();
    if (!online) throw const SocketException('offline');
    final file = File(_pendingAvatar!.path);
    final ref = FirebaseStorage.instance.ref().child('users/$uid/avatar.jpg');
    await ref
        .putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg', cacheControl: 'no-cache'),
        )
        .timeout(const Duration(seconds: 20));
    if (previousUrl != null && previousUrl.isNotEmpty) {
      try {
        final oldRef = FirebaseStorage.instance.refFromURL(previousUrl);
        if (oldRef.fullPath != ref.fullPath) {
          await oldRef.delete().timeout(const Duration(seconds: 10));
        }
      } catch (_) {}
    }
    return await ref.getDownloadURL().timeout(const Duration(seconds: 10));
  }

  Future<void> onSave() async {
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return;
    saving = true;
    notifyListeners();

    try {
      final u = navigatorKey.currentContext!.read<AppState>().currentUser;
      if (u == null) {
        showSnack('Usuário não encontrado.', error: true);
        return;
      }

      final online = await hasInternet();
      if (!online) {
        showSnack('Sem conexão com a internet. Tente novamente.', error: true);
        return;
      }

      final maybeAvatarUrl = await _uploadAvatarIfNeeded(
        u.id,
        previousUrl: u.avatarUrl,
      );
      final newAvatarUrl = maybeAvatarUrl ?? u.avatarUrl;

      final updated = UserModel(
        id: u.id,
        name: nameEC.text.trim(),
        email: emailEC.text.trim(),
        createdAt: u.createdAt,
        birthDate: _parseBirth(birthEC.text),
        weight: _parseNum(weightEC.text),
        height: _parseNum(heightEC.text),
        avatarUrl: newAvatarUrl,
      );

      await remote
          .updateUser(
            user: updated,
            notifications: notifications,
            weeklySummary: weeklySummary,
          )
          .timeout(const Duration(seconds: 15));

      avatarUrl = newAvatarUrl;
      _pendingAvatar = null;
      await navigatorKey.currentContext!.read<AppState>().setUser(updated);

      showSnack('Perfil atualizado com sucesso.');
    } on TimeoutException {
      showSnack('Operação demorou demais. Tente novamente.', error: true);
    } on SocketException {
      showSnack('Sem conexão com a internet. Tente novamente.', error: true);
    } on FirebaseException catch (e) {
      final net = e.code == 'network-request-failed';
      showSnack(
        net
            ? 'Falha de rede. Tente novamente.'
            : 'Erro ao salvar: ${e.message ?? e.code}',
        error: true,
      );
    } catch (_) {
      showSnack('Ocorreu um erro ao salvar.', error: true);
    } finally {
      saving = false;
      notifyListeners();
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
}
