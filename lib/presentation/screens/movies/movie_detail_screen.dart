import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:video_player/video_player.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/infrastructure/datasources/tmdb_datasource.dart';
import 'package:chocomil_movies_app_bv/infrastructure/repositories/movie_repository_impl.dart';

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
      create: (_) => MovieDetailProvider(
        movieRepository: MovieRepositoryImpl(TmdbDatasource()),
      )..loadMovieDetails(movie.id),
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
  // Controladores para ambos tipos de video
  YoutubePlayerController? _trailerController;
  VideoPlayerController? _cloudVideoController;
  bool _isCloudVideoInitialized = false;

  final List<int> _specialMovieIds = [969681, 1368337];

  final Map<int, Map<String, dynamic>> _cloudData = {
    969681: {
      'videoUrl':
          'https://odudxeahpastfjxjfvgm.supabase.co/storage/v1/object/public/peliculas/Spiderman.mp4',
      'images': [
        'https://odudxeahpastfjxjfvgm.supabase.co/storage/v1/object/public/peliculas/Spider-man-1.webp',
        'https://odudxeahpastfjxjfvgm.supabase.co/storage/v1/object/public/peliculas/spider-man-2.webp',
      ],
    },
    1368337: {
      'videoUrl':
          'https://odudxeahpastfjxjfvgm.supabase.co/storage/v1/object/public/peliculas/La_Odisea.mp4',
      'images': [
        'https://odudxeahpastfjxjfvgm.supabase.co/storage/v1/object/public/peliculas/La_Odisea_1.webp',
        'https://odudxeahpastfjxjfvgm.supabase.co/storage/v1/object/public/peliculas/La_Odisea_2.webp',
      ],
    },
  };

  bool get _isSpecialMovie => _specialMovieIds.contains(widget.movie.id);

  // Inicializa el reproductor de YouTube
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

  // Inicializa el reproductor de la Nube (.mp4)
  // Inicializa el reproductor de la Nube (.mp4)
  void _initCloudVideoController(String videoUrl) {
    if (_cloudVideoController != null) return;
    _cloudVideoController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isCloudVideoInitialized = true;
              });
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted && _cloudVideoController != null) {
                  setState(() {
                    _cloudVideoController!.setVolume(0.0);
                    _cloudVideoController!.play();
                  });
                }
              });
            }
          });
  }

  @override
  void dispose() {
    _trailerController?.close();
    _cloudVideoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<MovieDetailProvider>();

    // 1. Si es película especial, cargamos su video corto de Supabase
    if (_isSpecialMovie) {
      final videoUrl = _cloudData[widget.movie.id]!['videoUrl'];
      _initCloudVideoController(videoUrl);
    }

    // 2. Independientemente de si es especial o no, si TMDB nos da una llave de YouTube, inicializamos el tráiler
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
            if (_isSpecialMovie && _isCloudVideoInitialized)
              SliverAppBar(
                backgroundColor: AppColors.primaryDark,
                expandedHeight: 480,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.overlayLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _cloudVideoController!.value.size.width,
                          height: _cloudVideoController!.value.size.height,
                          child: VideoPlayer(_cloudVideoController!),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.overlayDark,
                              AppColors.primaryDark,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      if (!detailProvider.isLoading) ...[
                        if (detailProvider.movieLogoPath != null)
                          Positioned(
                            bottom: 25,
                            left: 20,
                            child: SizedBox(
                              width: 260,
                              height: 120,
                              child: Image.network(
                                detailProvider.movieLogoPath!,
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
                              widget.movie.title.toUpperCase(),
                              style: TextosEstilos.tituloHero,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              )
            else
              MovieDetailAppBarWidget(
                movie: widget.movie,
                isLoading: detailProvider.isLoading,
                movieLogoPath: detailProvider.movieLogoPath,
              ),

            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  // Unificamos el padding para que no se sienta apretado
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isSpecialMovie) ...[
                        const SectionTitleWidget(title: 'Imágenes Exclusivas'),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _cloudData[widget.movie.id]!['images'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _cloudData[widget
                                        .movie
                                        .id]!['images'][index],
                                    fit: BoxFit.cover,
                                    width: 250,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],

                      if (_trailerController != null) ...[
                        TrailerSectionWidget(controller: _trailerController!),
                        const SizedBox(height: 5),
                      ],

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.primaryLight,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Calificación: ${widget.movie.voteAverage.toStringAsFixed(1)}',
                            style: TextosEstilos.cuerpo.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const SectionTitleWidget(title: 'Sinopsis'),
                      const SizedBox(height: 4),
                      Text(
                        widget.movie.overview.isNotEmpty
                            ? widget.movie.overview
                            : 'No hay sinopsis disponible.',
                        style: TextosEstilos.cuerpo.copyWith(
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 5),

                      MovieActionsWidget(movie: widget.movie),

                      const SizedBox(height: 5),

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
                            context
                                .read<MovieDetailProvider>()
                                .loadMovieDetails(widget.movie.id);
                          },
                        )
                      else ...[
                        if (detailProvider.cast.isNotEmpty) ...[
                          CastSectionWidget(cast: detailProvider.cast),
                          const SizedBox(height: 5),
                        ],
                        // Comentarios
                        if (detailProvider.reviews.isNotEmpty) ...[
                          const SectionTitleWidget(
                            title: 'Comentarios de la Comunidad',
                          ),
                          const SizedBox(height: 4),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: detailProvider.reviews.length,
                            itemBuilder: (context, index) {
                              final review = detailProvider.reviews[index];
                              final author = review['author'] ?? 'Anónimo';
                              final content = review['content'] ?? '';
                              final rating =
                                  review['author_details']?['rating'];

                              return CommentWidget(
                                userName: author,
                                rating: rating != null
                                    ? (rating as num).toDouble()
                                    : 0.0,
                                comment: content,
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
