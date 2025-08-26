import 'package:flutter/material.dart';

import '../../../../core/shared/theme/app_colors.dart';
import '../../../../core/shared/ui/social_dot.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(thickness: 1, color: Color(0x11000000))),
        const SizedBox(width: 8),
        Text('ou', style: TextStyle(color: AppColors.textSub, fontSize: 13)),
        const SizedBox(width: 8),
        const Expanded(child: Divider(thickness: 1, color: Color(0x11000000))),
      ],
    );
  }
}

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SocialDot(icon: Icons.apple),
        SizedBox(width: 12),
        SocialDot(icon: Icons.g_mobiledata),
        SizedBox(width: 12),
        SocialDot(icon: Icons.facebook_rounded),
      ],
    );
  }
}
