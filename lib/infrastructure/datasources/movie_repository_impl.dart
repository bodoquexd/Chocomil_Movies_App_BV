/*import 'package:chocomil_movies_app_bv/domain/datasources/movie_datasources.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class MovieRepositoryImpl implements MovieRepositories {
  
  // Recibe cualquier datasource que cumpla con las reglas (como tu TmdbDatasource)
  final MovieDatasources datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getTrending({int page = 1}) {
    // Simplemente le delega el trabajo al trabajador
    return datasource.getTrending(page: page);
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) {
    // Simplemente le delega el trabajo al trabajador
    return datasource.getMoviesByGenre(genreId, page: page);
  }
}*/

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
}