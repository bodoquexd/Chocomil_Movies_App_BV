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
  String? movieLogoPath;

  Future<void> loadMovieDetails(int movieId) async {
    isLoading = true;
    errorMessage = null;
    cast = [];
    reviews = [];
    trailerKey = null;
    movieLogoPath = null; 
    notifyListeners(); 

    final apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';
    
    if (apiKey.isEmpty) {
      errorMessage = 'Error: No se encontró la API Key';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      //Obtener reparto (Cast)
      final castRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey&language=es-MX'));
      if (castRes.statusCode == 200) {
        final castData = json.decode(castRes.body);
        cast = (castData['cast'] as List).take(10).toList();
      }

      //Obtener Reviews
      final reviewsRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey'));
      if (reviewsRes.statusCode == 200) {
        final reviewsData = json.decode(reviewsRes.body);
        reviews = (reviewsData['results'] as List).take(5).toList();
      }

      //Obtener Tráiler
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

      //Obtener el Logo de la película
      final imagesRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/images?api_key=$apiKey&include_image_language=es,en,null'));
      if (imagesRes.statusCode == 200) {
        final imagesData = json.decode(imagesRes.body);
        final logos = imagesData['logos'] as List;
        
        if (logos.isNotEmpty) {
          final String logoPath = logos.first['file_path'];
          movieLogoPath = 'https://image.tmdb.org/t/p/w500$logoPath';
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