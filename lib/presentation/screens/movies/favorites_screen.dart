import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class FavoritesScreen extends StatelessWidget {
  static const String name = 'favorites_screen';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Text(
          'Mis películas favoritas',
          style: TextosEstilos.titulo,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}