import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_bookmark_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/heart_button_widget.dart'; // Nuevo import

class MovieCardWidget extends StatelessWidget {
  final Movie movie;

  const MovieCardWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final bool isFavorite = movieProvider.isFavorite(movie);
    final bool isSaved = movieProvider.isInWatchlist(movie);

    return SizedBox(
      width: 180,
      child: Card(
        elevation: 8,
        color: AppColors.backgroundBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      movie.posterPath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primary,
                          child: const Center(
                            child: Icon(
                              Icons.movie,
                              color: AppColors.textPrimary,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: HeartButtonWidget( // Usamos el widget centralizado
                      isFavorite: isFavorite,
                      onTap: () {
                        movieProvider.toggleFavorite(movie);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 75,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextosEstilos.cuerpo.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.primaryLight,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: TextosEstilos.cuerpo.copyWith(
                                color: AppColors.grayLight,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.85,
                          child: AnimatedBookmarkWidget(
                            isSaved: isSaved,
                            onTap: () {
                              movieProvider.toggleWatchlist(movie);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}