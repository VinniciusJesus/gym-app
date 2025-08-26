import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final h = height ?? 50;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: Size.fromHeight(h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
      onPressed: loading ? null : onPressed,
      child:
          loading
              ? SizedBox(
                height: h >= 50 ? 20 : 18,
                width: h >= 50 ? 20 : 18,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(label),
    );
  }
}
