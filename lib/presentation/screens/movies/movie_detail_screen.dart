import 'package:chocomil_movies_app_bv/presentation/widgets/custom_refresh_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:chocomil_movies_app_bv/presentation/utils/animation_utils.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_favorite_widget.dart';
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
  bool _isCastExpanded = false;

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
    final movieProvider = context.watch<MovieProvider>();

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
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.movie.backdropPath.isNotEmpty
                          ? widget.movie.backdropPath
                          : widget.movie.posterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
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
                            Colors.black.withOpacity(0.3),
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
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_trailerController != null) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitleWidget(title: 'Tráiler Oficial'),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: YoutubePlayer(
                                controller: _trailerController!,
                                aspectRatio: 16 / 9,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: AnimatedBookmarkWidget(
                                    isSaved: movieProvider.isInWatchlist(
                                      widget.movie,
                                    ),
                                    onTap: () {
                                      final isSaved = movieProvider
                                          .isInWatchlist(widget.movie);
                                      movieProvider.toggleWatchlist(
                                        widget.movie,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                isSaved
                                                    ? Icons.bookmark_remove
                                                    : Icons.bookmark,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                isSaved
                                                    ? 'Se eliminó de Guardados'
                                                    : 'Se guardó correctamente',
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              AppColors.backgroundBlack,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Mi lista',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: AnimatedFavoriteWidget(
                                    isFavorite: movieProvider.isFavorite(
                                      widget.movie,
                                    ),
                                    onPressed: () {
                                      final wasFavorite = movieProvider
                                          .isFavorite(widget.movie);
                                      movieProvider.toggleFavorite(
                                        widget.movie,
                                      );

                                      if (!wasFavorite) {
                                        showFloatingHeart(context);
                                      }

                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                wasFavorite
                                                    ? Icons.favorite_border
                                                    : Icons.favorite,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  wasFavorite
                                                      ? '"${widget.movie.title}" se eliminó de Favoritos'
                                                      : '"${widget.movie.title}" se añadió a Favoritos',
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              AppColors.backgroundBlack,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Favorito',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      if (detailProvider.isLoading)
                        const Center(
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
                          const SectionTitleWidget(title: 'Reparto Principal'),
                          const SizedBox(height: 12),

                          // Vista contraída (Horizontal)
                          if (!_isCastExpanded)
                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: detailProvider.cast.length > 3
                                    ? 4
                                    : detailProvider.cast.length,
                                itemBuilder: (context, index) {
                                  // Botón "Ver más"
                                  if (index == 3) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isCastExpanded = true;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        width: 85,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 85,
                                              width: 85,
                                              decoration: BoxDecoration(
                                                color: Colors.white10,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white70,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            const Text(
                                              'Ver más',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Tarjetas de actores
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                            height: 85,
                                            width: 85,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                                  height: 85,
                                                  width: 85,
                                                  color: Colors.grey,
                                                  child: const Icon(
                                                    Icons.person,
                                                  ),
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
                            )
                          // Vista expandida
                          else
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: detailProvider.cast.length,
                                  itemBuilder: (context, index) {
                                    final actor = detailProvider.cast[index];
                                    final profilePath = actor['profile_path'];
                                    final imageUrl = profilePath != null
                                        ? 'https://image.tmdb.org/t/p/w200$profilePath'
                                        : 'https://via.placeholder.com/150x150.png?text=No+Image';

                                    return Card(
                                      color: Colors.white10,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                            height: 55,
                                            width: 55,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                                  height: 55,
                                                  width: 55,
                                                  color: Colors.grey,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        title: Text(
                                          actor['name'] ?? 'Desconocido',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        subtitle: Text(
                                          actor['character'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Botón para volver a contraer la lista
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isCastExpanded = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white70,
                                  ),
                                  label: const Text(
                                    'Ver menos',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),
                        ],

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
                              final rating =
                                  review['author_details']?['rating'];

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
