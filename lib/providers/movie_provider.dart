import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String? _currentUserEmail;

  Future<void> loadFavoritesForUser(String email) async {
    _currentUserEmail = email;
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(
      'favoritos_$_currentUserEmail',
    );

    if (favoritesJson != null) {
      final List<dynamic> decodedList = jsonDecode(favoritesJson);
      favoriteMovies = decodedList.map((item) => Movie.fromJson(item)).toList();
    } else {
      favoriteMovies = [];
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
