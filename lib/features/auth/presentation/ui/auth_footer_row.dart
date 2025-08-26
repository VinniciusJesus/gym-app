import 'package:flutter/material.dart';

import '../../../../core/shared/theme/app_colors.dart';

class AuthFooterRow extends StatelessWidget {
  final String text;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthFooterRow({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(color: AppColors.textSub, fontSize: 13),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 13.5),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
