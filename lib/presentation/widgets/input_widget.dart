import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/color.dart';

class InputWidget extends StatelessWidget {

  final String label;
  final bool obscureText;

  const InputWidget({
    super.key,
    required this.label,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      obscureText: obscureText,

      style: TextStyle(
        color: ColorsApp.textPrimary,
      ),

      decoration: InputDecoration(

        labelText: label,

        labelStyle: TextStyle(
          color: ColorsApp.textPrimary,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

          borderSide: BorderSide(
            color: ColorsApp.background,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

          borderSide: BorderSide(
            color: ColorsApp.primary,
            width: 2,
          ),
        ),

      ),
    );
  }
}