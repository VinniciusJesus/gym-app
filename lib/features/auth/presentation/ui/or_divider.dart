import 'package:flutter/material.dart';

import '../../../../core/shared/theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1, color: Color(0x11000000))),
        SizedBox(width: 8),
        Text('ou', style: TextStyle(color: AppColors.textSub, fontSize: 13)),
        SizedBox(width: 8),
        Expanded(child: Divider(thickness: 1, color: Color(0x11000000))),
      ],
    );
  }
}
