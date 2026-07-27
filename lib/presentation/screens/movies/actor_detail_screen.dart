import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_row_section_widget.dart';

class ActorDetailScreen extends StatelessWidget {
  final dynamic actor;
  final MovieDetailProvider movieDetailProvider;

  const ActorDetailScreen({
    super.key,
    required this.actor,
    required this.movieDetailProvider,
  });

  Widget _buildDetailRow(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title ',
            style: TextosEstilos.cuerpo.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: value,
            style: TextosEstilos.cuerpo.copyWith(
              color: AppColors.grayLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actorId = actor['id'];
    final profilePath = actor['profile_path'];
    final imageUrl = profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://via.placeholder.com/300x450.png?text=No+Image';

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 65,
        title: Image.asset(
          'assets/images/icon_app.png',
          height: 58,
          fit: BoxFit.contain,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Aquí aplicamos el Hero widget usando el ID del actor
                Hero(
                  tag: 'actor-profile-$actorId',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: 140,
                      height: 210,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 140,
                        height: 210,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor['name'] ?? 'Desconocido',
                        style: TextosEstilos.titulo.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        actor['character'] ?? '',
                        style: TextosEstilos.cuerpo.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<Map<String, dynamic>>(
                        future: movieDetailProvider.getActorDetails(actorId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: AppColors.primaryLight,
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SizedBox();
                          }
                          final data = snapshot.data!;
                          final birthday = data['birthday'] ?? 'Desconocido';
                          final placeOfBirth =
                              data['place_of_birth'] ?? 'Desconocido';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Nacimiento:', birthday),
                              const SizedBox(height: 8),
                              _buildDetailRow('Lugar:', placeOfBirth),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Biografía
            const SectionTitleWidget(title: 'Biografía'),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: movieDetailProvider.getActorDetails(actorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryLight,
                    ),
                  );
                }
                final data = snapshot.data ?? {};
                final bio = data['biography']?.toString().isNotEmpty == true
                    ? data['biography']
                    : 'Biografía no disponible en español.';

                return Text(
                  bio,
                  style: TextosEstilos.cuerpo.copyWith(
                    color: AppColors.grayLight,
                    fontSize: 15,
                    height: 1.4,
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            FutureBuilder<Map<String, dynamic>>(
              future: movieDetailProvider.getActorMovies(actorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryLight,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty ||
                    snapshot.data!['cast'] == null ||
                    (snapshot.data!['cast'] as List).isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitleWidget(title: 'Películas Destacadas'),
                      const SizedBox(height: 12),
                      Text(
                        'Filmografía no disponible.',
                        style: TextosEstilos.cuerpo.copyWith(
                          color: AppColors.grayLight,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                }

                final rawMovies = snapshot.data!['cast'] as List<dynamic>;
                final displayedMovies = rawMovies.take(15).toList();
                
                final List<Movie> moviesList = displayedMovies.map((movieData) {
                  final posterPath = movieData['poster_path'];
                  final backdropPath = movieData['backdrop_path'];
                  final fullPosterPath = posterPath != null && posterPath.toString().isNotEmpty
                      ? 'https://image.tmdb.org/t/p/w500$posterPath'
                      : '';

                  final fullBackdropPath = backdropPath != null && backdropPath.toString().isNotEmpty
                      ? 'https://image.tmdb.org/t/p/w500$backdropPath'
                      : '';

                  return Movie(
                    adult: movieData['adult'] ?? false,
                    backdropPath: fullBackdropPath,
                    genreIds: List<String>.from(
                      (movieData['genre_ids'] ?? []).map((e) => e.toString()),
                    ),
                    id: movieData['id'] ?? 0,
                    originalLanguage: movieData['original_language'] ?? '',
                    originalTitle:
                        movieData['original_title'] ??
                        movieData['title'] ??
                        movieData['name'] ??
                        '',
                    overview: movieData['overview'] ?? '',
                    popularity:
                        (movieData['popularity'] as num?)?.toDouble() ?? 0.0,
                    posterPath: fullPosterPath, 
                    releaseDate:
                        movieData['release_date'] != null &&
                            movieData['release_date'].toString().isNotEmpty
                        ? DateTime.parse(movieData['release_date'])
                        : DateTime(1900),
                    title: movieData['title'] ?? movieData['name'] ?? '',
                    video: movieData['video'] ?? false,
                    voteAverage:
                        (movieData['vote_average'] as num?)?.toDouble() ?? 0.0,
                    voteCount: movieData['vote_count'] ?? 0,
                  );
                }).toList();

                return MovieRowSectionWidget(
                  title: 'Películas Destacadas',
                  movies: moviesList,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}