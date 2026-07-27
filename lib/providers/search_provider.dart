import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class SearchProvider extends ChangeNotifier {
  final MovieRepositories movieRepository;
  List<Movie> popularMovies = [];

  String _query = '';
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  Timer? _debouncer;

  SearchProvider({required this.movieRepository}) {
    loadPopularMovies();
  }

  Future<void> loadPopularMovies() async {
    try {
      popularMovies = await movieRepository.getTrending();
      notifyListeners();
    } catch (e) {
      popularMovies = [];
    }
  }

  String get query => _query;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  void updateQuery(String value) {
    _query = value;
    if (value.trim().isEmpty) {
      _debouncer?.cancel();
      _query = '';
      _searchResults = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    if (_debouncer?.isActive ?? false) _debouncer!.cancel();
    _debouncer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final movies = await movieRepository.searchMovies(value);

        if (_query == value) {
          _searchResults = movies;
          _isLoading = false;
          notifyListeners();
        }
      } catch (e) {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearSearch() {
    _debouncer?.cancel();
    _query = '';
    _searchResults = [];
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
