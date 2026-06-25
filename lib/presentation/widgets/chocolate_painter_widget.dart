import 'package:flutter/material.dart';

class ChocolatePainter extends CustomPainter {
  final Color color;

  ChocolatePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.6);

    path.quadraticBezierTo(size.width * 0.1, size.height * 0.9, size.width * 0.2, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.4, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height * 1.0, size.width * 0.6, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.4, size.width * 0.8, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.9, size.height * 1.1, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}