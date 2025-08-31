import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final secure = const FlutterSecureStorage();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (e, s) {
    FirebaseCrashlytics.instance.recordError(e, s, fatal: true);
    return true;
  };
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final authNotifier = AuthNotifier(FirebaseAuth.instance);
  final router = buildRouter(authNotifier, FirebaseAnalytics.instance);

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<FlutterSecureStorage>.value(value: secure),
        ChangeNotifierProvider<AuthNotifier>.value(value: authNotifier),
        Provider<FirebaseAnalytics>.value(value: FirebaseAnalytics.instance),
      ],
      child: App(router: router),
    ),
  );
}

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._auth) {
    _sub = _auth.authStateChanges().listen((_) => notifyListeners());
  }
  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _sub;
  User? get user => _auth.currentUser;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter buildRouter(AuthNotifier auth, FirebaseAnalytics analytics) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (ctx, state) {
      final loggedIn = auth.user != null;
      final loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
    observers: [FirebaseAnalyticsObserver(analytics: analytics)],
    routes: [
      GoRoute(path: '/', builder: (ctx, st) => const LoginPage()),
      GoRoute(path: '/login', builder: (ctx, st) => const LoginPage()),
      GoRoute(path: '/signup', builder: (ctx, st) => const SignUpPage()),
    ],
  );
}

class App extends StatelessWidget {
  const App({super.key, required this.router});
  final GoRouter router;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        routerConfig: router,
      ),
    );
  }
}
