import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';
// Importamos el nuevo widget animado
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_favorite_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text("Mis Favoritos"),
      ),

      body: movieProvider.favoriteMovies.isEmpty
          ? Center(
              child: Text(
                "No tienes películas favoritas",
                style: TextosEstilos.titulo,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: movieProvider.favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.favoriteMovies[index];

                return Card(
                  color: AppColors.backgroundBlack,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.posterPath,
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(
                      movie.title,
                      style: const TextStyle(color: Colors.white),
                    ),

                    subtitle: Text(
                      "⭐ ${movie.voteAverage.toStringAsFixed(1)}",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    // Implementación del widget con la animación de latido
                    trailing: AnimatedFavoriteWidget(
                      isFavorite: true,
                      onPressed: () {
                        movieProvider.toggleFavorite(movie);
                      },
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}