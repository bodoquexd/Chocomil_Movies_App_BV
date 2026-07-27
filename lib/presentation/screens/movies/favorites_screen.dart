import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_favorite_widget.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/pdf_generator_service.dart'; // Importa el servicio PDF

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Movie> _currentFavorites = [];

  @override
  void initState() {
    super.initState();
    _currentFavorites = List.from(context.read<MovieProvider>().favoriteMovies);
  }

  void _removeItem(int index, Movie movie) {
    final AnimatedListState? animatedList = _listKey.currentState;
    animatedList?.removeItem(
      index,
      (context, animation) =>
          _buildMovieCard(movie, animation, index, isRemoving: true),
      duration: const Duration(milliseconds: 300),
    );
    setState(() {
      _currentFavorites.removeAt(index);
    });

    context.read<MovieProvider>().toggleFavorite(movie);
  }

  // Método para exportar a PDF
  void _exportPdf() {
    if (_currentFavorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No hay películas en favoritos para exportar"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    PdfGeneratorService.generateAndShareFavoritesPdf(_currentFavorites);
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final favoriteMoviesFromProvider = movieProvider.favoriteMovies;

    if (_currentFavorites.length != favoriteMoviesFromProvider.length) {
      _currentFavorites = List.from(favoriteMoviesFromProvider);
    }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitleWidget(title: 'Mis Favoritos'),
                if (_currentFavorites.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: const Text("Exportar PDF"),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _currentFavorites.isEmpty
                ? Center(
                    child: Text(
                      "No tienes películas favoritas",
                      style: TextosEstilos.cuerpo.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : AnimatedList(
                    key: _listKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    initialItemCount: _currentFavorites.length,
                    itemBuilder: (context, index, animation) {
                      return _buildMovieCard(
                        _currentFavorites[index],
                        animation,
                        index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(
    Movie movie,
    Animation<double> animation,
    int index, {
    bool isRemoving = false,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          color: AppColors.backgroundBlack,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterPath,
                width: 55,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 55,
                  color: AppColors.grayLight,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            ),
            title: Text(
              movie.title,
              style: TextosEstilos.cuerpo.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
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
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            trailing: AnimatedFavoriteWidget(
              isFavorite: true,
              onPressed: () {
                _removeItem(index, movie);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '"${movie.title}" se ha quitado de favoritos',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.backgroundBlack,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
              },
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: movie),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
