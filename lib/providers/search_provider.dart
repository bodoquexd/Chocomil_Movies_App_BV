import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';

class SearchProvider extends ChangeNotifier {
  // Necesitamos el repositorio para hacer la búsqueda real
  final MovieRepositories movieRepository;

  String _query = '';
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  SearchProvider({required this.movieRepository});

  // Getters
  String get query => _query;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  /// Actualiza el query y dispara la búsqueda en la API
  void updateQuery(String value) async {
    _query = value;
    
    // Si el usuario borra todo, limpiamos los resultados inmediatamente
    if (value.trim().isEmpty) {
      _searchResults = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Llamamos al repositorio que a su vez llama al TmdbDatasource
      final movies = await movieRepository.searchMovies(value);
      
      // Validamos que los resultados correspondan al último query escrito
      // (Previene problemas si una petición lenta llega después de una rápida)
      if (_query == value) {
        _searchResults = movies;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Método auxiliar para limpiar la búsqueda por completo
  void clearSearch() {
    _query = '';
    _searchResults = [];
    _isLoading = false;
    notifyListeners();
  }
}