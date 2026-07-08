import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

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

                  // APARTADO DEL CORAZÓN MODIFICADO CON LA ANIMACIÓN
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

// WIDGET ESPECIALIZADO PARA LA ANIMACIÓN DE LATIDO (PULSE EFFECT)
class _AnimatedHeartButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _AnimatedHeartButton({
    required this.isFavorite,
    required this.onTap,
  });

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

    // Animación de escala tipo "rebote elástico"
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _AnimatedHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TRUCO CLAVE: Si el valor de favorito cambió tras la reconstrucción del Provider,
    // disparamos la animación inmediatamente.
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