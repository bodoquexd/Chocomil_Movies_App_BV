
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

abstract class MovieRepositories {
  Future<List<Movie>> getTrending({int page = 1});

  Future<List<Movie>> getMoviesByGenre(
    int genreId, {
    int page = 1,
  });

  // NUEVO
  Future<List<Movie>> searchMovies(
    String query, {
    int page = 1,
  });
}