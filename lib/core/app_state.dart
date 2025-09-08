import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/main.dart';

import '../features/auth/data/datasources/local_user_store.dart';
import '../features/auth/data/models/user_model.dart';

class AppState extends ChangeNotifier {
  final LocalUserStore _local = LocalUserStore();
  UserModel? currentUser;
  bool premium = false;
  bool initialized = false;

  Future<void> init() async {
    currentUser = await _local.read();
    initialized = true;
    notifyListeners();
  }

  Future<void> setUser(UserModel? user) async {
    currentUser = user;
    if (user == null) {
      await _local.clear();
    } else {
      await _local.save(user);
    }
    notifyListeners();
  }

  void setPremium(bool value) {
    premium = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await _local.clear();
    currentUser = null;
    premium = false;
    notifyListeners();
    if (navigatorKey.currentContext!.mounted) {
      navigatorKey.currentContext!.go('/login');
    }
  }
}
