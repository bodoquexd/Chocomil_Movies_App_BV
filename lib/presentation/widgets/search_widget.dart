import 'package:flutter/material.dart';
// TODO: Verifica que las rutas a tus archivos de estilos y colores sean correctas
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextosEstilos.cuerpo.copyWith(
        color: AppColors.primaryDark,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar película...',
        hintStyle: TextosEstilos.cuerpo.copyWith(
          color: AppColors.textHint,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textHint, 
        ),
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.inputBorder, 
            width: 2,
          ),
        ),
      ),
    );
  }
}