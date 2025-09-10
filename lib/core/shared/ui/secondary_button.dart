import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.padding,
  });
  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;
    return OutlinedButton.icon(
      onPressed: disabled ? null : onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label:
          loading
              ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: disabled ? Colors.grey : AppColors.primaryDark,
        side: BorderSide(
          color:
              disabled
                  ? Colors.grey.withOpacity(0.5)
                  : AppColors.primaryDark.withOpacity(0.35),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
