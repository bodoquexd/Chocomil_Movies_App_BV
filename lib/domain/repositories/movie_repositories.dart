import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

abstract class MovieRepositories {
  Future<List<Movie>> getTrending({int page = 1});
  Future<String?> getMovieLogo(int movieId);
  Future<List<dynamic>> getMovieCast(int movieId);
  Future<List<dynamic>> getMovieReviews(int movieId);
  Future<String?> getMovieTrailer(int movieId);

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});

  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<Map<String, dynamic>> getActorDetails(int actorId);
  Future<Map<String, dynamic>> getActorMovies(int actorId);
}
