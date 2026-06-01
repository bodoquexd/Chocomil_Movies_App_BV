import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors.dart';

class InputWidget extends StatelessWidget {
  final String label;
  final bool obscureText;

  const InputWidget({super.key, required this.label, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,

      style: TextStyle(color: AppColors.textPrimary),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: TextStyle(
          color: AppColors.textPrimary, 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.background, 
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primary, 
            width: 2,
          ),
        ),
      ),
    );
  }
}
