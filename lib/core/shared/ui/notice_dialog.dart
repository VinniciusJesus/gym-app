import 'package:flutter/material.dart';
import 'package:gym/main.dart';

import '../theme/app_colors.dart';
import 'primary_button.dart';

enum NoticeKind { success, error, info }

void showSnack(String message, {bool error = false}) {
  final ctx = navigatorKey.currentContext;
  final messengerA = ctx != null ? ScaffoldMessenger.maybeOf(ctx) : null;
  final ScaffoldMessengerState? messengerB =
      scaffoldMessengerKey.currentState is ScaffoldMessengerState
          ? scaffoldMessengerKey.currentState
          : null;
  final messenger = messengerA ?? messengerB;
  if (messenger != null) {
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }
}

class NoticeDialog extends StatefulWidget {
  final NoticeKind kind;
  final String title;
  final String message;
  final List<Widget>? actions;

  const NoticeDialog({
    super.key,
    required this.kind,
    required this.title,
    required this.message,
    this.actions,
  });

  @override
  State<NoticeDialog> createState() => _NoticeDialogState();
}

class _NoticeDialogState extends State<NoticeDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: .98,
      end: 1,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, .02),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Color get _accent {
    switch (widget.kind) {
      case NoticeKind.error:
        return const Color(0xFFD32F2F);
      case NoticeKind.success:
        return AppColors.primary;
      case NoticeKind.info:
        return const Color(0xFF2962FF);
    }
  }

  IconData get _icon {
    switch (widget.kind) {
      case NoticeKind.error:
        return Icons.close_rounded;
      case NoticeKind.success:
        return Icons.check_rounded;
      case NoticeKind.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SlideTransition(
          position: _slide,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF212529),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF5F6368),
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (widget.actions != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: widget.actions!,
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              label: 'OK',
                              height: 42,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -26,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(_icon, color: _accent, size: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Dialogs {
  static Future<T?> show<T>(
    BuildContext context, {
    required NoticeKind kind,
    required String title,
    required String message,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (_) => NoticeDialog(
            kind: kind,
            title: title,
            message: message,
            actions: actions,
          ),
    );
  }

  static Future<void> success(
    BuildContext context,
    String message, {
    String title = 'Tudo certo',
    bool dismissible = true,
  }) {
    return show<void>(
      context,
      kind: NoticeKind.success,
      title: title,
      message: message,
      barrierDismissible: dismissible,
    );
  }

  static Future<void> error(
    BuildContext context,
    String message, {
    String title = 'Ops',
    bool dismissible = false,
  }) {
    return show<void>(
      context,
      kind: NoticeKind.error,
      title: title,
      message: message,
      barrierDismissible: dismissible,
    );
  }

  static Future<bool> confirm(
    BuildContext context, {
    String title = 'Confirmar',
    String message = 'Tem certeza?',
    String cancelText = 'Cancelar',
    String okText = 'Confirmar',
  }) async {
    final res = await show<bool>(
      context,
      kind: NoticeKind.info,
      title: title,
      message: message,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 42,
          child: PrimaryButton(
            label: okText,
            height: 42,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    );
    return res ?? false;
  }
}
