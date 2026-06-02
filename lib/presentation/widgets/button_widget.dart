import 'package:chocomil_movies_app_bv/resources/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles.dart'; // Importamos tus estilos
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        texto, 
        style: TextosEstilos.boton,
      ),
    );
  }
}