import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SocialDot extends StatelessWidget {
  final IconData icon;
  const SocialDot({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textMain, size: 20),
    );
  }
}
