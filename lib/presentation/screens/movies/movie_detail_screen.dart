import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_bookmark_widget.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailProvider()..loadMovieDetails(movie.id),
      child: _MovieDetailContent(movie: movie),
    );
  }
}

class _MovieDetailContent extends StatefulWidget {
  final Movie movie;
  const _MovieDetailContent({required this.movie});

  @override
  State<_MovieDetailContent> createState() => _MovieDetailContentState();
}

class _MovieDetailContentState extends State<_MovieDetailContent> {
  YoutubePlayerController? _trailerController;

  void _initYoutubeController(String videoId) {
    _trailerController ??= YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<MovieDetailProvider>();
    final movieProvider = context.watch<MovieProvider>();
    if (detailProvider.trailerKey != null && _trailerController == null) {
      _initYoutubeController(detailProvider.trailerKey!);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    icon: Icon(
                      movieProvider.isFavorite(widget.movie)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      movieProvider.toggleFavorite(widget.movie);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedBookmarkWidget(
                  isSaved: movieProvider.isInWatchlist(widget.movie),
                  onTap: () {
                    movieProvider.toggleWatchlist(widget.movie);
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.movie.posterPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          AppColors.primaryDark,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          widget.movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const SectionTitleWidget(title: 'Sinopsis'),
                    const SizedBox(height: 12),
                    Text(
                      widget.movie.overview.isNotEmpty
                          ? widget.movie.overview
                          : 'No hay sinopsis disponible.',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (detailProvider.isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: AppColors.textPrimary,
                        ),
                      )
                    else if (detailProvider.errorMessage != null)
                      Center(
                        child: Text(
                          detailProvider.errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    else ...[
                      if (detailProvider.cast.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const SectionTitleWidget(title: 'Reparto Principal'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: detailProvider.cast.length,
                            itemBuilder: (context, index) {
                              final actor = detailProvider.cast[index];
                              final profilePath = actor['profile_path'];
                              final imageUrl = profilePath != null
                                  ? 'https://image.tmdb.org/t/p/w200$profilePath'
                                  : 'https://via.placeholder.com/150x150.png?text=No+Image';

                              return Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: 85,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        height: 85,
                                        width: 85,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          height: 85,
                                          width: 85,
                                          color: Colors.grey,
                                          child: const Icon(Icons.person),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      actor['name'] ?? 'Desconocido',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_trailerController != null) ...[
                        const SectionTitleWidget(title: 'Tráiler Oficial'),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: YoutubePlayer(
                            controller: _trailerController!,
                            aspectRatio: 16 / 9,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (detailProvider.reviews.isNotEmpty) ...[
                        const SectionTitleWidget(
                          title: 'Comentarios de la Comunidad',
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: detailProvider.reviews.length,
                          itemBuilder: (context, index) {
                            final review = detailProvider.reviews[index];
                            final author = review['author'] ?? 'Anónimo';
                            final content = review['content'] ?? '';
                            final rating = review['author_details']?['rating'];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: CommentWidget(
                                userName: author,
                                rating: rating != null
                                    ? (rating as num).toDouble()
                                    : 0.0,
                                comment: content,
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        const Text(
                          'Aún no hay comentarios para esta película.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}