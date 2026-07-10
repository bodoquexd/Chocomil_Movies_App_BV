import 'package:flutter/material.dart';

class HeartButtonWidget extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const HeartButtonWidget({
    super.key, 
    required this.isFavorite, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        // Esta es la clave: combinamos rotación y escala
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: RotationTransition(
              turns: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          // Key es indispensable para que AnimatedSwitcher detecte el cambio
          key: ValueKey<bool>(isFavorite),
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.redAccent : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}