import 'dart:math';

import 'package:flutter/material.dart';

class CircularRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double fraction;

  CircularRevealClipper({required this.center, required this.fraction});

  @override
  Path getClip(Size size) {
    final radius = size.longestSide * fraction;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}

class SquareClipper extends CustomClipper<Path> {
  final Offset center;
  final double fraction;

  SquareClipper({required this.center, required this.fraction});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Calcula a distância máxima do centro a qualquer canto da tela
    final maxRadius = sqrt(
      pow(max(center.dx, size.width - center.dx), 2) +
          pow(max(center.dy, size.height - center.dy), 2),
    );

    // Calcula o raio atual baseado na fração da animação
    final currentRadius = maxRadius * fraction;

    // Cria um caminho circular centrado no ponto de clique
    path.addOval(Rect.fromCircle(center: center, radius: currentRadius));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // Reclipa sempre que a fração da animação mudar
    return oldClipper is SquareClipper && oldClipper.fraction != fraction;
  }
}

Offset getWidgetCenter(GlobalKey key) {
  final RenderBox? renderBox =
      key.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox != null) {
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    return Offset(position.dx + size.width / 2, position.dy + size.height / 2);
  } else {
    // Fallback: retorna o centro da tela se não conseguir obter a posição
    // (Isso não deve acontecer em um cenário normal)
    final screenCenter = MediaQuery.of(
      key.currentContext!,
    ).size.center(Offset.zero);
    print(
      "Aviso: Não foi possível obter a posição do widget. Usando centro da tela.",
    );
    return screenCenter;
  }
}
