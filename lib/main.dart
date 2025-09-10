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
import 'package:gym/features/auth/presentation/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_state.dart';
import 'core/shared/navigation/custom_transitions.dart';
import 'features/auth/data/datasources/auth_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/plans/presentation/controllers/ficha_controller.dart';
import 'features/plans/presentation/pages/ficha_create_page.dart';
import 'features/plans/presentation/pages/plans_page.dart';
import 'features/profile/presentation/controllers/profile_controller.dart';
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

  final router = buildRouter(FirebaseAnalytics.instance);

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<FlutterSecureStorage>.value(value: secure),
        Provider<FirebaseAuth>.value(value: FirebaseAuth.instance),
        Provider<FirebaseAnalytics>.value(value: FirebaseAnalytics.instance),
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        Provider<AuthService>(
          create:
              (context) => AuthService(
                context.read<FirebaseAuth>(),
                context.read<FirebaseAnalytics>(),
              ),
        ),
        ChangeNotifierProvider<ProfileController>(
          create:
              (context) => ProfileController(auth: context.read<AuthService>()),
        ),
        ChangeNotifierProvider<PlansController>(
          create: (context) => PlansController(),
        ),
        ChangeNotifierProvider<FichaController>(
          create: (context) => FichaController(),
        ),
      ],
      child: App(router: router),
    ),
  );
}

GoRouter buildRouter(FirebaseAnalytics analytics) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,

    observers: [FirebaseAnalyticsObserver(analytics: analytics)],
    routes: [
      GoRoute(path: '/', builder: (ctx, st) => SplashPage()),
      GoRoute(path: '/login', builder: (ctx, st) => LoginPage()),
      GoRoute(path: '/home', builder: (ctx, st) => FichaCreatePage()),
      GoRoute(
        path: '/signup',
        pageBuilder:
            (context, state) => slideFromRight(
              page: const SignUpPage(),
              key: const ValueKey('signup'),
            ),
      ),
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
