import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieDetailProvider extends ChangeNotifier {
  bool isLoading = true;
  List<dynamic> cast = [];
  List<dynamic> reviews = [];
  String? trailerKey;
  String? errorMessage;

  Future<void> loadMovieDetails(int movieId) async {
    isLoading = true;
    errorMessage = null;
    cast = [];
    reviews = [];
    trailerKey = null;
    notifyListeners(); 

    final apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';
    
    if (apiKey.isEmpty) {
      errorMessage = 'Error: No se encontró la API Key';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // 1. Obtener reparto (Cast)
      final castRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey&language=es-MX'));
      if (castRes.statusCode == 200) {
        final castData = json.decode(castRes.body);
        cast = (castData['cast'] as List).take(10).toList();
      }

      final reviewsRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey'));
      if (reviewsRes.statusCode == 200) {
        final reviewsData = json.decode(reviewsRes.body);
        reviews = (reviewsData['results'] as List).take(5).toList();
      }

      // 3. Obtener Tráiler
      final videoRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey&language=es-MX'));
      if (videoRes.statusCode == 200) {
        final videoData = json.decode(videoRes.body);
        final videos = videoData['results'] as List;
        for (var v in videos) {
          if (v['site'] == 'YouTube' && (v['type'] == 'Trailer' || v['type'] == 'Teaser')) {
            trailerKey = v['key'];
            break;
          }
        }
        
        if (trailerKey == null) {
          final videoResEn = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey'));
          if (videoResEn.statusCode == 200) {
            final videoDataEn = json.decode(videoResEn.body);
            for (var v in videoDataEn['results']) {
              if (v['site'] == 'YouTube' && v['type'] == 'Trailer') {
                trailerKey = v['key'];
                break;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error cargando detalles: $e');
      errorMessage = 'Error de conexión';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}