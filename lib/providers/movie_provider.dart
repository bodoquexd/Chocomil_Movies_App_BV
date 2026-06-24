import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepositories movieRepository;

  List<Movie> featuredMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> actionMovies = [];
  List<Movie> sciFiMovies = [];
  List<Movie> comedyMovies = [];
  List<Movie> animationMovies = [];

  bool isLoading = true;
  String? errorMessage;

  MovieProvider({required this.movieRepository});

  Future<void> loadAllMovies() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final results = await Future.wait([
        movieRepository.getTrending(),
        movieRepository.getMoviesByGenre(28),  
        movieRepository.getMoviesByGenre(878), 
        movieRepository.getMoviesByGenre(35),  
        movieRepository.getMoviesByGenre(16),  
      ]);

      trendingMovies  = results[0];
      actionMovies    = results[1];
      sciFiMovies     = results[2];
      comedyMovies    = results[3];
      animationMovies = results[4];

      featuredMovies  = trendingMovies.take(5).toList(); 
      
      isLoading = false;
    } catch (e) {
      errorMessage = 'Error al conectar con TMDB. Revisa tu conexión.';
      isLoading = false;
    } finally {
      notifyListeners(); 
    }
  }
}