import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';

import 'package:chocomil_movies_app_bv/presentation/widgets/custom_refresh_indicator_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/custom_error_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_detail_app_bar_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/trailer_section_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_actions_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/cast_section_widget.dart';

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
  void dispose() {
    _trailerController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<MovieDetailProvider>();

    if (detailProvider.trailerKey != null && _trailerController == null) {
      _initYoutubeController(detailProvider.trailerKey!);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await context.read<MovieDetailProvider>().loadMovieDetails(
            widget.movie.id,
          );
        },
        child: CustomScrollView(
          slivers: [
            MovieDetailAppBarWidget(
              movie: widget.movie,
              isLoading: detailProvider.isLoading,
              movieLogoPath: detailProvider.movieLogoPath,
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_trailerController != null) 
                        TrailerSectionWidget(controller: _trailerController!),

                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Calificación: ${widget.movie.voteAverage.toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 25),
                      MovieActionsWidget(movie: widget.movie),
                      const SizedBox(height: 25),

                      if (detailProvider.isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.textPrimary,
                          ),
                        )
                      else if (detailProvider.errorMessage != null)
                        CustomErrorWidget(
                          imagePath: 'assets/images/error_404.png',
                          title: '¡Ups! Algo salió mal',
                          message: detailProvider.errorMessage!,
                          buttonText: 'Reintentar',
                          onRetry: () {
                            context.read<MovieDetailProvider>().loadMovieDetails(widget.movie.id);
                          },
                        )

                      else ...[
                        if (detailProvider.cast.isNotEmpty) 
                          CastSectionWidget(cast: detailProvider.cast),

                        // Comentarios
                        if (detailProvider.reviews.isNotEmpty) ...[
                          const SectionTitleWidget(
                            title: 'Comentarios de la Comunidad',
                          ),
                          const SizedBox(height: 2),
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
      ),
    );
  }
}