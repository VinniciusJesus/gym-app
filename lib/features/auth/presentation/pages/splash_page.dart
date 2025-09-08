import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_state.dart';
import '../../../../core/shared/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final app = context.read<AppState>();
      if (!app.initialized) app.init();
    });
  }

  void _tryNavigate(BuildContext context, AppState app) {
    if (!app.initialized || _didNavigate) return;
    _didNavigate = true;
    final dest = app.currentUser != null ? '/home' : '/login';
    if (context.mounted) context.go(dest); // ou context.replace(dest);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, app, __) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _tryNavigate(context, app),
        );
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 100,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(24),
                  //     boxShadow: const [
                  //       BoxShadow(
                  //         color: Color(0x33000000),
                  //         blurRadius: 16,
                  //         offset: Offset(0, 8),
                  //       ),
                  //     ],
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: const FlutterLogo(size: 60),
                  // ),
                  const SizedBox(height: 28),
                  const Text(
                    'Preparando seus treinos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
