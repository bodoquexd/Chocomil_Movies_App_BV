import 'dart:convert';
import 'package:flutter/material.dart';
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
        releaseDate:
            DateTime.tryParse(m['release_date'] ?? '') ?? DateTime.now(),
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
      '&language=es-MX'
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
      '&language=es-MX'
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
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final encodedQuery = Uri.encodeComponent(query);

    final url = Uri.parse(
      '$_baseUrl/search/movie'
      '?api_key=$_apiKey'
      '&language=es-MX'
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

  @override
  Future<String?> getMovieLogo(int movieId) async {
    final url = Uri.parse(
      '$_baseUrl/movie/$movieId/images'
      '?api_key=$_apiKey'
      '&include_image_language=MX,en,null',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> logos = data['logos'] ?? [];
        if (logos.isNotEmpty) {
          final String logoPath = logos.first['file_path'];
          return getImageUrl(logoPath);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<dynamic>> getMovieCast(int movieId) async {
    final url = Uri.parse(
      '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=es-MX',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['cast'] as List).take(10).toList();
      }
    } catch (e) {
      debugPrint('Error en Cast: $e');
    }
    return [];
  }

  @override
  Future<List<dynamic>> getMovieReviews(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/reviews?api_key=$_apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List).take(5).toList();
      }
    } catch (e) {
      debugPrint('Error en Reviews: $e');
    }
    return [];
  }

  @override
  Future<String?> getMovieTrailer(int movieId) async {
    try {
      // Intento en Español
      final urlEs = Uri.parse(
        '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=es-MX',
      );
      final responseEs = await http.get(urlEs);
      if (responseEs.statusCode == 200) {
        final data = json.decode(responseEs.body);
        for (var v in data['results']) {
          if (v['site'] == 'YouTube' &&
              (v['type'] == 'Trailer' || v['type'] == 'Teaser')) {
            return v['key'];
          }
        }
      }

      // Fallback en Inglés si no hay tráiler en español
      final urlEn = Uri.parse(
        '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey',
      );
      final responseEn = await http.get(urlEn);
      if (responseEn.statusCode == 200) {
        final dataEn = json.decode(responseEn.body);
        for (var v in dataEn['results']) {
          if (v['site'] == 'YouTube' && v['type'] == 'Trailer') {
            return v['key'];
          }
        }
      }
    } catch (e) {
      debugPrint('Error en Trailer: $e');
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> getActorDetails(int actorId) async {
    final url = Uri.parse(
      '$_baseUrl/person/$actorId?api_key=$_apiKey&language=es-MX',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error obteniendo actor: $e');
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> getActorMovies(int actorId) async {
    final url = Uri.parse(
      '$_baseUrl/person/$actorId/movie_credits?api_key=$_apiKey&language=es-MX',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error obteniendo películas del actor: $e');
    }
    return {};
  }
}
