import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final TextInputAction action;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;

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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
      ),
      style: const TextStyle(fontSize: 14.5),
      textInputAction: action,
      keyboardType: keyboardType,
      validator: validator, // <- permite Validatorless
    );
  }
}
