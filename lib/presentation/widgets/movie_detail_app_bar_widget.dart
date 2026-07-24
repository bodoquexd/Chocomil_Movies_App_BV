import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class MovieDetailAppBarWidget extends StatelessWidget {
  final Movie movie;
  final bool isLoading;
  final String? movieLogoPath;

  const MovieDetailAppBarWidget({
    super.key,
    required this.movie,
    required this.isLoading,
    this.movieLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primaryDark,
      expandedHeight: 480,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo (Backdrop o Poster)
            Image.network(
              movie.backdropPath.isNotEmpty
                  ? movie.backdropPath
                  : movie.posterPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.white54,
                ),
              ),
            ),

            // Gradiente oscuro
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    AppColors.primaryDark,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),

            // Logo o Título de la película
            if (!isLoading) ...[
              if (movieLogoPath != null)
                Positioned(
                  bottom: 25,
                  left: 20,
                  child: SizedBox(
                    width: 260,
                    height: 120,
                    child: Image.network(
                      movieLogoPath!,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomLeft,
                      errorBuilder: (_, _, _) => const SizedBox(),
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 25,
                  left: 20,
                  right: 20,
                  child: Text(
                    movie.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
