import 'package:flutter/material.dart';

class AnimatedHeartWidget extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedHeartWidget({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<AnimatedHeartWidget> createState() => _AnimatedHeartWidgetState();
}

class _AnimatedHeartWidgetState extends State<AnimatedHeartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // Secuencia: Crece a 1.4x y regresa a 1.0x con rebote
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)), // Efecto de gelatina/rebote
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap(); // Ejecuta la lógica para guardar/quitar de favoritos
    
    // Dispara la animación siempre que se toque
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Fondo oscuro semitransparente
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : Colors.white70,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}