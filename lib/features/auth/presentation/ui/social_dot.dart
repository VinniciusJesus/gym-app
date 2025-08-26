import 'package:flutter/material.dart';

class SocialDot extends StatelessWidget {
  final IconData icon;
  const SocialDot({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Color(0xFF1D1D1F), size: 20),
    );
  }
}
