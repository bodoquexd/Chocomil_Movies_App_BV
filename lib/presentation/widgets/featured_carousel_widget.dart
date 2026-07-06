import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/featured_movie_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';

class FeaturedCarouselWidget extends StatelessWidget {
  final PageController controller;
  final List<Movie> movies;
  final Function(int) onPageChanged;

  const FeaturedCarouselWidget({
    super.key,
    required this.controller,
    required this.movies,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: PageView.builder(
        controller: controller,
        itemCount: movies.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double value = 1.0;
              if (controller.position.haveDimensions) {
                value = controller.page! - index;
                value = (1 - (value.abs() * 0.35)).clamp(0.85, 1.0);
              }
              return Opacity(
                opacity: value,
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),

              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: FeaturedMovieWidget(
                  title: movie.title,
                  imageUrl: movie.backdropPath,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}