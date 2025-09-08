import 'package:flutter/material.dart';

import '../../../../core/shared/theme/app_colors.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const Header({required this.title, required this.subtitle, super.key});
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
