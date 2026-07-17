import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepositories movieRepository;
  MovieProvider({required this.movieRepository});

  List<Movie> featuredMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> actionMovies = [];
  List<Movie> sciFiMovies = [];
  List<Movie> comedyMovies = [];
  List<Movie> animationMovies = [];
  List<Movie> favoriteMovies = [];
  List<Movie> watchlistMovies = []; 

  String? _currentUserEmail;
  final Map<String, List<String>> _avatarCategories = {};
  Map<String, List<String>> get avatarCategories => _avatarCategories;

  Future<void> loadAvatars() async {
    if (_avatarCategories.isNotEmpty) return; 

    final apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';
    
    if (apiKey.isEmpty) {
      debugPrint('Error: No se encontró la API Key para avatares');
      return;
    }
    final Map<String, int> sagasMovies = {
      'Marvel (Avengers)': 24428,     
      'Star Wars': 11,              
      'Harry Potter': 671,            
      'El Señor de los Anillos': 120, 
      'Pixar (Toy Story)': 862,       
    };

    try {
      await Future.wait(sagasMovies.entries.map((entry) async {
        final url = Uri.parse('https://api.themoviedb.org/3/movie/${entry.value}/credits?api_key=$apiKey&language=es-MX');
        
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<dynamic> cast = data['cast'];

          final avatarsList = cast
              .where((actor) => actor['profile_path'] != null)
              .map((actor) => 'https://image.tmdb.org/t/p/w200${actor['profile_path']}')
              .take(10) // Limitamos a 10 personajes por saga
              .cast<String>()
              .toList();
              
          if (avatarsList.isNotEmpty) {
            _avatarCategories[entry.key] = avatarsList;
          }
        }
      }));
      
      notifyListeners(); 
    } catch (e) {
      debugPrint('Error al obtener avatares por sagas: $e');
    }
  }

  Future<void> loadFavoritesForUser(String email) async {
    _currentUserEmail = email;
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Cargar Favoritos
    final String? favoritesJson = prefs.getString(
      'favoritos_$_currentUserEmail',
    );

    if (favoritesJson != null) {
      final List<dynamic> decodedList = jsonDecode(favoritesJson);
      favoriteMovies = decodedList.map((item) => Movie.fromJson(item)).toList();
    } else {
      favoriteMovies = [];
    }

    final String? watchlistJson = prefs.getString(
      'watchlist_$_currentUserEmail',
    );

    if (watchlistJson != null) {
      final List<dynamic> decodedWatchlist = jsonDecode(watchlistJson);
      watchlistMovies = decodedWatchlist.map((item) => Movie.fromJson(item)).toList();
    } else {
      watchlistMovies = [];
    }

    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return favoriteMovies.any((m) => m.id == movie.id);
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie)) {
      favoriteMovies.removeWhere((m) => m.id == movie.id);
    } else {
      favoriteMovies.add(movie);
    }

    notifyListeners();
    await _saveFavoritesToStorage();
  }

  Future<void> _saveFavoritesToStorage() async {
    if (_currentUserEmail == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      favoriteMovies.map((movie) => movie.toJson()).toList(),
    );

    await prefs.setString('favoritos_$_currentUserEmail', encodedList);
  }

  bool isInWatchlist(Movie movie) {
    return watchlistMovies.any((m) => m.id == movie.id);
  }

  Future<void> toggleWatchlist(Movie movie) async {
    if (isInWatchlist(movie)) {
      watchlistMovies.removeWhere((m) => m.id == movie.id);
    } else {
      watchlistMovies.add(movie);
    }

    notifyListeners();
    await _saveWatchlistToStorage();
  }

  Future<void> _saveWatchlistToStorage() async {
    if (_currentUserEmail == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      watchlistMovies.map((movie) => movie.toJson()).toList(),
    );

    await prefs.setString('watchlist_$_currentUserEmail', encodedList);
  }

  bool isLoading = true;
  String? errorMessage;

  Future<void> loadAllMovies() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      
      final results = await Future.wait([
        movieRepository.getTrending(),
        movieRepository.getMoviesByGenre(28),
        movieRepository.getMoviesByGenre(878),
        movieRepository.getMoviesByGenre(35),
        movieRepository.getMoviesByGenre(16),
      ]);

      trendingMovies = results[0];
      actionMovies = results[1];
      sciFiMovies = results[2];
      comedyMovies = results[3];
      animationMovies = results[4];

      featuredMovies = trendingMovies.take(5).toList();
    } catch (e) {
      final errorString = e.toString().toLowerCase();

      if (e is SocketException ||
          errorString.contains('socketexception') ||
          errorString.contains('failed host lookup')) {
        errorMessage = 'error_internet';
      } else if (errorString.contains('404')) {
        errorMessage = 'error_404';
      } else if (errorString.contains('500')) {
        errorMessage = 'error_500';
      } else {
        errorMessage = 'error_desconocido';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}