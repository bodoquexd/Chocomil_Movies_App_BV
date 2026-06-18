import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class WatchlistScreen extends StatelessWidget {
  static const String name = 'watchlist_screen';

  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Text(
          'Mi lista de películas',
          style: TextosEstilos.titulo,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}