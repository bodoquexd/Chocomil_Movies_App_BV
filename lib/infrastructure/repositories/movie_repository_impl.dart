import 'package:chocomil_movies_app_bv/domain/datasources/movie_datasources.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class MovieRepositoryImpl implements MovieRepositories {
  
  final MovieDatasources datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getTrending({int page = 1}) {
    return datasource.getTrending(page: page);
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) {
    return datasource.getMoviesByGenre(genreId, page: page);
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) {
    return datasource.searchMovies(query, page: page);
  }

  @override
  Future<String?> getMovieLogo(int movieId) {
    return datasource.getMovieLogo(movieId);
  }

  @override
  Future<List<dynamic>> getMovieCast(int movieId) {
    return datasource.getMovieCast(movieId);
  }

  @override
  Future<List<dynamic>> getMovieReviews(int movieId) {
    return datasource.getMovieReviews(movieId);
  }

  @override
  Future<String?> getMovieTrailer(int movieId) {
    return datasource.getMovieTrailer(movieId);
  }

  @override
  Future<Map<String, dynamic>> getActorDetails(int actorId) {
    return datasource.getActorDetails(actorId);
  }

  @override
  Future<Map<String, dynamic>> getActorMovies(int actorId) {
    return datasource.getActorMovies(actorId);
  }
  
}