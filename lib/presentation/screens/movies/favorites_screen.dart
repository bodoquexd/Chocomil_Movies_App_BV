import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_favorite_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final favoriteMovies = movieProvider.favoriteMovies;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        children: [
          // Encabezado Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.brown[900],
            child: Text(
              "Mis Favoritos",
              textAlign: TextAlign.center,
              style: TextosEstilos.titulo.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),

          // Lista
          Expanded(
            child: favoriteMovies.isEmpty
                ? Center(
                    child: Text(
                      "No tienes películas favoritas",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteMovies.length,
                    itemBuilder: (context, index) {
                      final movie = favoriteMovies[index];
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
                          trailing: AnimatedFavoriteWidget(
                            isFavorite: true,
onPressed: () {
  movieProvider.toggleFavorite(movie);

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.favorite_border,
              color: Colors.white, // Igual que el otro
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '"${movie.title}" se ha quitado de la lista de favoritos',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundBlack, // Igual que el otro
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
},
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
