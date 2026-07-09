import 'package:flutter/material.dart';

class AnimatedFavoriteWidget extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const AnimatedFavoriteWidget({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<AnimatedFavoriteWidget> createState() => _AnimatedFavoriteWidgetState();
}

class _AnimatedFavoriteWidgetState extends State<AnimatedFavoriteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    // Definimos una animación que agranda el corazón y lo regresa a su tamaño original
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Dispara la animación desde el inicio
    _controller.forward(from: 0.0);
    // Ejecuta la lógica del Provider pasados unos milisegundos para que se aprecie el efecto completo
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : Colors.white70,
          size: 28,
        ),
        onPressed: _handleTap,
      ),
    );
  }
}