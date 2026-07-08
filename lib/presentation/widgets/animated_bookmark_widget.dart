import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBookmarkWidget extends StatefulWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const AnimatedBookmarkWidget({
    super.key,
    required this.isSaved,
    required this.onTap,
  });

  @override
  State<AnimatedBookmarkWidget> createState() => _AnimatedBookmarkWidgetState();
}

class _AnimatedBookmarkWidgetState extends State<AnimatedBookmarkWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Animación 1: Giro completo de 360 grados (2 * pi) con un efecto de retroceso al final
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Animación 2: Salto sutil mientras gira
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedBookmarkWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Dispara la animación inmediatamente si el Provider cambia el estado de guardado
    if (oldWidget.isSaved != widget.isSaved) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            // Aplicamos la rotación sobre el eje Z
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Fondo oscuro semitransparente
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  // Color ámbar para distinguir la Watchlist de los Favoritos (rojo)
                  color: widget.isSaved ? Colors.amber : Colors.white70,
                  size: 22,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}