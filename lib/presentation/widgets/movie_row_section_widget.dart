import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart'; // Importamos tus colores

class MovieRowSectionWidget extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const MovieRowSectionWidget({
    super.key, 
    required this.title, 
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(title: title),
        const SizedBox(height: 14),

        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.05, 0.95, 1.0], 
              colors: [
                Colors.transparent,
                AppColors.textPrimary, 
                AppColors.textPrimary, 
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          
          child: SizedBox(
            height: 310, 
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 4), 
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCardWidget(
                  title: movie.title,
                  imageUrl: movie.posterPath,
                  rating: movie.voteAverage,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}