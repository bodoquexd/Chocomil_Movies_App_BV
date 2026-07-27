import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class MovieDetailProvider extends ChangeNotifier {
  final MovieRepositories movieRepository;

  MovieDetailProvider({required this.movieRepository});

  bool isLoading = true;
  List<dynamic> cast = [];
  List<dynamic> reviews = [];
  String? trailerKey;
  String? errorMessage;
  String? movieLogoPath;

  Future<void> loadMovieDetails(int movieId) async {
    isLoading = true;
    errorMessage = null;
    cast = [];
    reviews = [];
    trailerKey = null;
    movieLogoPath = null;
    notifyListeners();

    try {
      final results = await Future.wait(<Future<dynamic>>[
        movieRepository.getMovieCast(movieId),
        movieRepository.getMovieReviews(movieId),
        movieRepository.getMovieTrailer(movieId),
        movieRepository.getMovieLogo(movieId),
      ]);

      cast = results[0] as List<dynamic>;
      reviews = results[1] as List<dynamic>;
      trailerKey = results[2] as String?;
      movieLogoPath = results[3] as String?;
    } catch (e) {
      debugPrint('Error cargando detalles: $e');
      errorMessage = 'Error de conexión';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getActorDetails(int actorId) async {
    return await movieRepository.getActorDetails(actorId);
  }

  Future<Map<String, dynamic>> getActorMovies(int actorId) async {
    return await movieRepository.getActorMovies(actorId);
  }
}
