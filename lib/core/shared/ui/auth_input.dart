import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputStyles {
  static InputDecoration decoration({
    required BuildContext context,
    required String label,
    required String hint,
    Widget? suffix,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    const baseRadius = BorderRadius.all(Radius.circular(12));
    const baseSide = BorderSide(width: 0, color: Colors.white);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: const OutlineInputBorder(
        borderRadius: baseRadius,
        borderSide: baseSide,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: baseRadius,
        borderSide: baseSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: baseRadius,
        borderSide: BorderSide(width: 1.6, color: primary),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: baseRadius,
        borderSide: BorderSide(width: 1, color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: baseRadius,
        borderSide: BorderSide(width: 1.2, color: Color(0xFFEF4444)),
      ),
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
      labelStyle: const TextStyle(fontSize: 14),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minHeight: 40, minWidth: 40),
    );
  }
}

class AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final TextInputAction action;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const AuthInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.action = TextInputAction.next,
    this.keyboardType,
    this.suffix,
    this.validator,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      decoration: AppInputStyles.decoration(
        context: context,
        label: label,
        hint: hint,
        suffix: suffix,
      ),
      style: const TextStyle(fontSize: 14.5),
      textInputAction: action,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: 1,
    );
  }
}
