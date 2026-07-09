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

class _AnimatedFavoriteWidgetState extends State<AnimatedFavoriteWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // --- ANIMACIÓN MÁS LLAMATIVA ---
        setState(() => _scale = 2.0); // Aumentamos a 2.0 para que sea grande
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() => _scale = 1.0);
        
        // Ejecutamos la acción
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 400), // Más lento para que se note
        curve: Curves.elasticOut, // Rebote muy marcado
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : Colors.grey,
          size: 28, // Un poco más grande para que impacte
        ),
      ),
    );
  }
}