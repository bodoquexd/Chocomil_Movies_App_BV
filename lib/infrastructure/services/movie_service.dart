import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _baseUrlImage = 'https://image.tmdb.org/t/p/w500';
  
  final String _apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';

  String getImageUrl(String? path) {
    if (path == null) return 'https://picsum.photos/500/750'; 
    return '$_baseUrlImage$path';
  }

  Future<List<Map<String, dynamic>>> getTrending() async {
    final url = Uri.parse('$_baseUrl/trending/movie/day?api_key=$_apiKey&language=es-ES');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Error al cargar tendencias de TMDB');
    }
  }

  Future<List<Map<String, dynamic>>> getMoviesByGenre(int genreId) async {
    final url = Uri.parse('$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId&language=es-ES&sort_by=popularity.desc');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Error al cargar género $genreId');
    }
  }
}