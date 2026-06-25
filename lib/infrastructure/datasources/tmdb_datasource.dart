/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chocomil_movies_app_bv/domain/datasources/movie_datasources.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

// 1. Heredamos de tu clase abstracta
class TmdbDatasource implements MovieDatasources {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';

  String getImageUrl(String? path) {
    if (path == null) return 'https://picsum.photos/500/750'; 
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  List<Movie> _jsonToMovies(List<dynamic> jsonList) {
    return jsonList.map((m) => Movie(
      adult: m['adult'] ?? false,
      backdropPath: m['backdrop_path'] != null ? getImageUrl(m['backdrop_path']) : '',
      genreIds: List<String>.from((m['genre_ids'] ?? []).map((e) => e.toString())),
      id: m['id'] ?? 0,
      originalLanguage: m['original_language'] ?? '',
      originalTitle: m['original_title'] ?? '',
      overview: m['overview'] ?? '',
      popularity: (m['popularity'] ?? 0).toDouble(),
      posterPath: m['poster_path'] != null ? getImageUrl(m['poster_path']) : '',
      releaseDate: DateTime.tryParse(m['release_date'] ?? '') ?? DateTime.now(),
      title: m['title'] ?? m['name'] ?? 'Sin título',
      video: m['video'] ?? false,
      voteAverage: (m['vote_average'] ?? 0).toDouble(),
      voteCount: m['vote_count'] ?? 0,
    )).toList();
  }

  @override
  Future<List<Movie>> getTrending({int page = 1}) async {
    final url = Uri.parse('$_baseUrl/trending/movie/day?api_key=$_apiKey&language=es-ES&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _jsonToMovies(data['results']); 
    } else {
      throw Exception('Error al cargar tendencias de TMDB');
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final url = Uri.parse('$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId&language=es-ES&sort_by=popularity.desc&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _jsonToMovies(data['results']);
    } else {
      throw Exception('Error al cargar género $genreId');
    }
  }
}*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:chocomil_movies_app_bv/domain/datasources/movie_datasources.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

class TmdbDatasource implements MovieDatasources {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';

  /// Convierte path de imagen de TMDB a URL completa
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://picsum.photos/500/750';
    }
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  /// Convierte JSON de TMDB a lista de Movies
  List<Movie> _jsonToMovies(List<dynamic> jsonList) {
    return jsonList.map((m) {
      return Movie(
        adult: m['adult'] ?? false,
        backdropPath: m['backdrop_path'] != null
            ? getImageUrl(m['backdrop_path'])
            : '',
        genreIds: List<String>.from(
          (m['genre_ids'] ?? []).map((e) => e.toString()),
        ),
        id: m['id'] ?? 0,
        originalLanguage: m['original_language'] ?? '',
        originalTitle: m['original_title'] ?? '',
        overview: m['overview'] ?? '',
        popularity: (m['popularity'] ?? 0).toDouble(),
        posterPath: m['poster_path'] != null
            ? getImageUrl(m['poster_path'])
            : '',
        releaseDate: DateTime.tryParse(m['release_date'] ?? '') ??
            DateTime.now(),
        title: m['title'] ?? m['name'] ?? 'Sin título',
        video: m['video'] ?? false,
        voteAverage: (m['vote_average'] ?? 0).toDouble(),
        voteCount: m['vote_count'] ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<Movie>> getTrending({int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/trending/movie/day'
      '?api_key=$_apiKey'
      '&language=es-ES'
      '&page=$page',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _jsonToMovies(data['results']);
    } else {
      throw Exception('Error al cargar películas en tendencia');
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/discover/movie'
      '?api_key=$_apiKey'
      '&with_genres=$genreId'
      '&language=es-ES'
      '&sort_by=popularity.desc'
      '&page=$page',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _jsonToMovies(data['results']);
    } else {
      throw Exception('Error al cargar películas por género');
    }
  }

  @override
  Future<List<Movie>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    final encodedQuery = Uri.encodeComponent(query);

    final url = Uri.parse(
      '$_baseUrl/search/movie'
      '?api_key=$_apiKey'
      '&language=es-ES'
      '&query=$encodedQuery'
      '&include_adult=false'
      '&page=$page',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _jsonToMovies(data['results']);
    } else {
      throw Exception('Error al buscar películas: $query');
    }
  }
}