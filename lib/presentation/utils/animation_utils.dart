import 'package:flutter/material.dart';

void showFloatingHeart(BuildContext context) {
  final overlay = Overlay.of(context);
  
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1700),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final opacity = value < 0.75 ? 1.0 : (1.0 - value) / 0.25;
          
          return Transform.scale(
            scale: value * 1.5,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 120, 
              ),
            ),
          );
        },
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(milliseconds: 1700), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}