import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class GifThumb extends StatefulWidget {
  final String url;
  final double size;

  const GifThumb({super.key, required this.url, this.size = 48});

  @override
  State<GifThumb> createState() => _GifThumbState();
}

class _GifThumbState extends State<GifThumb>
    with SingleTickerProviderStateMixin {
  late final GifController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = GifController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Gif(
          controller: _ctrl,
          // anima automaticamente em loop quando os frames estiverem disponíveis
          autostart: Autostart.loop,
          image: NetworkImage(widget.url),
          fit: BoxFit.cover,
          // loader leve
          placeholder:
              (_) => Container(
                color: const Color(0xFFEFF4F8),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
        ),
      ),
    );
  }
}
