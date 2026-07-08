import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_bookmark_widget.dart'; // IMPORTANTE: Tu widget animado

class MovieCardWidget extends StatelessWidget {
  final Movie movie;

  const MovieCardWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final bool isFavorite = movieProvider.isFavorite(movie);
    final bool isSaved = movieProvider.isInWatchlist(
      movie,
    ); // Verifica si está guardada

    return SizedBox(
      width: 180,
      child: Card(
        elevation: 8,
        color: AppColors.backgroundBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  // FAVORITOS (Corazón arriba a la derecha)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _AnimatedHeartButton(
                      isFavorite: isFavorite,
                      onTap: () {
                        movieProvider.toggleFavorite(movie);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // APARTADO INFERIOR (Títulos, Rating y Guardado)
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
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                      style: TextosEstilos.cuerpo.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),

                    // ESTA ES LA MAGIA PARA PONERLO A LA DERECHA DEL RATING
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Lado Izquierdo: Estrella y calificación
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

                        // Lado Derecho: Tu nuevo botón animado de guardado
                        Transform.scale(
                          scale:
                              0.85, // Un poco más pequeño para que no estorbe
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

// WIDGET HELPER DEL CORAZÓN
class _AnimatedHeartButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _AnimatedHeartButton({required this.isFavorite, required this.onTap});

  @override
  State<_AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<_AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.4,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _AnimatedHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black54,
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: 20,
          ),
        ),
      ),
    );
  }
}
