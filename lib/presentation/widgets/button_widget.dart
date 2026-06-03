import 'package:chocomil_movies_app_bv/resources/colors.dart';
import 'package:flutter/material.dart';

// Creamos un widget personalizado llamado ButtonWidget
// Hereda de StatelessWidget porque el botón no cambia su estado internamente
class ButtonWidget extends StatelessWidget {
  // Variable para guardar el texto que mostrará el boton
  final String texto;

  // Variable para guardar la función que se ejecutará al presionar el boton
  final VoidCallback onPressed;

  // Constructor del widget
  // required significa que estos parámetros son obligatorios
  const ButtonWidget({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Retorna un botón elevado
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,

        foregroundColor: AppColors.primary,

        padding: const EdgeInsets.symmetric(vertical: 15),
      ),

      // Acción que se ejecuta al presionar el botón
      onPressed: onPressed,

      // Contenido interno del botón
      // Muestra el texto recibido en la variable texto
      child: Text(texto),
    );
  }
}
