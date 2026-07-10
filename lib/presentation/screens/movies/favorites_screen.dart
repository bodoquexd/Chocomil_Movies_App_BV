import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/animated_favorite_widget.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart'; 
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
    // 1. Obtenemos el estado de la lista animada
    final AnimatedListState? animatedList = _listKey.currentState;
    animatedList?.removeItem(
      index,
      (context, animation) => _buildMovieCard(movie, animation, index, isRemoving: true),
      duration: const Duration(milliseconds: 300), 
    );
    setState(() {
      _currentFavorites.removeAt(index);
    });
    
    context.read<MovieProvider>().toggleFavorite(movie);
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
      body: Column(
        children: [
          // Encabezado Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.brown[900],
            child: Text(
              "Mis Favoritos",
              textAlign: TextAlign.center,
              style: TextosEstilos.titulo.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),

          // Lista
          Expanded(
            child: _currentFavorites.isEmpty
                ? Center(
                    child: Text(
                      "No tienes películas favoritas",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : AnimatedList(
                    key: _listKey, 
                    padding: const EdgeInsets.all(16),
                    initialItemCount: _currentFavorites.length,
                    itemBuilder: (context, index, animation) {
                      return _buildMovieCard(_currentFavorites[index], animation, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMovieCard(Movie movie, Animation<double> animation, int index, {bool isRemoving = false}) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          color: AppColors.backgroundBlack,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterPath,
                width: 55,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              movie.title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "⭐ ${movie.voteAverage.toStringAsFixed(1)}",
              style: const TextStyle(color: Colors.white70),
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
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '"${movie.title}" se ha quitado de la lista de favoritos',
                              style: const TextStyle(
                                color: Colors.white,
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
          ),
        ),
      ),
    );
  }
}