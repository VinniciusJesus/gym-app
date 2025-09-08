import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation.dart';

PageRouteBuilder<T> slideFromBottom<T>({
  required Widget page,
  Duration duration = const Duration(milliseconds: 400),
}) {
  return PageRouteBuilder(
    transitionDuration: duration,
    pageBuilder: (_, animation, __) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curved),
        child: page,
      );
    },
  );
}

CustomTransitionPage<T> slideFromRight<T>({
  required Widget page,
  Duration duration = const Duration(milliseconds: 400),
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: duration,
    child: page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // começa da direita
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}

PageRouteBuilder<T> slideFromTop<T>({
  required Widget page,
  Duration duration = const Duration(milliseconds: 400),
}) {
  return PageRouteBuilder(
    transitionDuration: duration,
    pageBuilder: (_, animation, __) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1), // De cima
          end: Offset.zero,
        ).animate(curved),
        child: page,
      );
    },
  );
}

PageRouteBuilder circularRevealRoute({
  required Widget page,
  required Offset center,
  Duration duration = const Duration(milliseconds: 700),
}) {
  return PageRouteBuilder(
    transitionDuration: duration,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, __, child) {
      return ClipPath(
        clipper: CircularRevealClipper(
          center: center,
          fraction: animation.value,
        ),
        child: child,
      );
    },
  );
}

PageRouteBuilder scaleFromRectRoute({
  required BuildContext context,
  required Widget page,
  required Rect origin,
  Duration duration = const Duration(milliseconds: 500),
  Curve curve = Curves.easeInOut,
}) {
  final size = MediaQuery.of(context).size;
  final alignment = Alignment(
    (origin.center.dx / size.width) * 2 - 1,
    (origin.center.dy / size.height) * 2 - 1,
  );

  return PageRouteBuilder(
    transitionDuration: duration,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
      return ScaleTransition(
        scale: curvedAnimation,
        alignment: alignment,
        child: child,
      );
    },
  );
}

PageRouteBuilder expandingIconRoute({
  required Widget page,
  required Offset centerOffset,
  Duration duration = const Duration(milliseconds: 600), // Duração ajustada
}) {
  return PageRouteBuilder(
    transitionDuration: duration,
    reverseTransitionDuration: duration, // Duração para a transição reversa
    opaque: false, // Permite ver a tela anterior por baixo durante a transição
    barrierColor:
        Colors.transparent, // Sem cor de barreira sobre a tela anterior
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Curva para a animação para um efeito mais suave
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutExpo, // Curva que começa rápido e desacelera
        reverseCurve: Curves.easeInExpo, // Curva reversa
      );

      // Converte o Offset global do centro do ícone para um Alignment (-1 a 1)
      // Isso define o ponto de origem da animação de escala.
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final alignment = Alignment(
        (centerOffset.dx / screenWidth) * 2 - 1,
        (centerOffset.dy / screenHeight) * 2 - 1,
      );

      // Animação de Fade para a página de destino
      final fadeTransition = FadeTransition(
        opacity: curvedAnimation, // Usa a animação curvada
        child: child,
      );

      // Animação de Scale para a página de destino, originando do centro do ícone
      final scaleTransition = ScaleTransition(
        scale: curvedAnimation, // Usa a animação curvada
        alignment: alignment, // Alinha a escala com o centro do ícone
        child: fadeTransition, // Encapsula a animação de fade
      );

      // A animação Hero para o ícone em si é tratada separadamente pelo Flutter
      // se houver Widgets Hero com a mesma tag em ambas as telas.
      // Esta PageRouteBuilder cuida da animação de fundo (escala/fade).

      return scaleTransition;
    },
  );
}
