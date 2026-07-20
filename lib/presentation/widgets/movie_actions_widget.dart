import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_favorite_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_bookmark_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/utils/animation_utils.dart';

class MovieActionsWidget extends StatelessWidget {
  final Movie movie;

  const MovieActionsWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider directamente dentro de este widget
    final movieProvider = context.watch<MovieProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón "Mi lista"
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: Center(
                child: AnimatedBookmarkWidget(
                  isSaved: movieProvider.isInWatchlist(movie),
                  onTap: () {
                    final isSaved = movieProvider.isInWatchlist(movie);
                    movieProvider.toggleWatchlist(movie);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              isSaved ? Icons.bookmark_remove : Icons.bookmark,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              isSaved
                                  ? 'Se eliminó de Guardados'
                                  : 'Se guardó correctamente',
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.backgroundBlack,
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
            ),
            const SizedBox(height: 2),
            const Text(
              'Mi lista',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),

        // Botón "Favorito"
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: Center(
                child: AnimatedFavoriteWidget(
                  isFavorite: movieProvider.isFavorite(movie),
                  onPressed: () {
                    final wasFavorite = movieProvider.isFavorite(movie);
                    movieProvider.toggleFavorite(movie);

                    if (!wasFavorite) {
                      showFloatingHeart(context);
                    }

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              wasFavorite
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                wasFavorite
                                    ? '"${movie.title}" se eliminó de Favoritos'
                                    : '"${movie.title}" se añadió a Favoritos',
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.backgroundBlack,
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
            ),
            const SizedBox(height: 2),
            const Text(
              'Favorito',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}