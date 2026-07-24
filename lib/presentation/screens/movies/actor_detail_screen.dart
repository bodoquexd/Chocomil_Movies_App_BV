import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart'; 
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart'; 

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
            ), //
          ),
          TextSpan(
            text: value,
            style: TextosEstilos.cuerpo.copyWith(
              color: AppColors.grayLight,
              fontSize: 14,
            ), //
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          actor['name'] ?? 'Desconocido',
          style: TextosEstilos.subtitulo, //
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
                ClipRRect(
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
                      child: const Icon(Icons.person, size: 60, color: AppColors.textPrimary),
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
                          color: AppColors.textSecondary, // Usamos textSecondary
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<Map<String, dynamic>>(
                        future: movieDetailProvider.getActorDetails(actorId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(color: AppColors.primaryLight); //
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SizedBox();
                          }
                          final data = snapshot.data!;
                          final birthday = data['birthday'] ?? 'Desconocido';
                          final placeOfBirth = data['place_of_birth'] ?? 'Desconocido';

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
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryLight)); //
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

            // Películas destacadas
            const SectionTitleWidget(title: 'Películas Destacadas'),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: movieDetailProvider.getActorMovies(actorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryLight)), //[cite: 4]
                  );
                }
                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty ||
                    snapshot.data!['cast'] == null ||
                    (snapshot.data!['cast'] as List).isEmpty) {
                  return Text(
                    'Filmografía no disponible.',
                    style: TextosEstilos.cuerpo.copyWith(
                      color: AppColors.grayLight, 
                      fontSize: 14,
                    ),
                  );
                }

                final movies = snapshot.data!['cast'] as List<dynamic>;
                final displayedMovies = movies.take(15).toList();

                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: displayedMovies.length,
                    itemBuilder: (context, index) {
                      final movie = displayedMovies[index];
                      final moviePosterPath = movie['poster_path'];
                      final movieImageUrl = moviePosterPath != null
                          ? 'https://image.tmdb.org/t/p/w185$moviePosterPath'
                          : 'https://via.placeholder.com/150x225.png?text=No+Poster';
                      final movieTitle = movie['title'] ?? 'Sin título';

                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movieImageUrl,
                                height: 140,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  height: 140,
                                  width: 100,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.movie, size: 40, color: AppColors.textPrimary), //[cite: 4]
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              movieTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextosEstilos.cuerpo.copyWith(
                                color: AppColors.grayLight, 
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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