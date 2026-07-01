/*import 'dart:async'; // 💡 Requerido para el Timer (Debounce)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {

  Timer? _debounce;
  
  @override
  String get searchFieldLabel => 'Buscar películas...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            context.read<SearchProvider>().clearSearch();
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        // Limpiamos el temporizador al salir por seguridad
        _debounce?.cancel();
        context.read<SearchProvider>().clearSearch();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      context.read<SearchProvider>().updateQuery(query);
    }
    return _buildSearchResults();
  }

  // 💡 AQUÍ SUCEDE LA MAGIA DE LA BÚSQUEDA MIENTRAS ESCRIBES
  @override
  Widget buildSuggestions(BuildContext context) {
    final searchProvider = context.read<SearchProvider>();

    // Solo activamos la actualización si el texto es diferente al que ya se buscó
    if (query != searchProvider.query) {
      
      // Si el usuario sigue escribiendo rápido, cancelamos la búsqueda anterior
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      // Esperamos 500 milisegundos de inactividad para disparar la búsqueda real
      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchProvider.updateQuery(query);
      });
    }

    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        
        if (searchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No se encontraron resultados para: "$query"',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // 💡 CAMBIO A 2 COLUMNAS
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: searchProvider.searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,         // Reducido a 2 tarjetas por fila
            crossAxisSpacing: 12,      // Espacio lateral ligeramente mayor
            mainAxisSpacing: 15,       // Espacio inferior
            childAspectRatio: 0.65,    // Proporción ideal para 2 columnas con tu tarjeta original
          ),
          itemBuilder: (context, index) {
            final movie = searchProvider.searchResults[index];
            
            return GestureDetector(
              onTap: () {
                _debounce?.cancel(); // Cancelar timer si selecciona una película rápido
                close(context, movie);
              },
              child: MovieCardWidget(
                title: movie.title,
                imageUrl: movie.posterPath,
                rating: movie.voteAverage,
              ),
            ); 
          },
        );
      },
    );
  }
}
*/

/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  Timer? _debounce;
  
  @override
  String get searchFieldLabel => 'Buscar películas...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            context.read<SearchProvider>().clearSearch();
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        _debounce?.cancel();
        // Ya no borramos la búsqueda aquí para que se quede guardada en memoria
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      context.read<SearchProvider>().updateQuery(query);
    }
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchProvider = context.read<SearchProvider>();

    if (query != searchProvider.query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchProvider.updateQuery(query);
      });
    }

    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        
        if (searchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No se encontraron resultados para: "$query"',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: searchProvider.searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,         
            crossAxisSpacing: 12,      
            mainAxisSpacing: 15,       
            childAspectRatio: 0.65,    
          ),
          itemBuilder: (context, index) {
            final movie = searchProvider.searchResults[index];
            
            return GestureDetector(
              onTap: () {
                _debounce?.cancel(); 
                close(context, movie);
              },
              child: MovieCardWidget(
                title: movie.title,
                imageUrl: movie.posterPath,
                rating: movie.voteAverage,
              ),
            ); 
          },
        );
      },
    );
  }
}*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  Timer? _debounce;
  
  @override
  String get searchFieldLabel => 'Buscar películas...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            context.read<SearchProvider>().clearSearch();
          },
        )
    ];
  }

  // 💡 SOLUCIÓN 1: Al tocar la flechita de atrás, SÍ borramos todo del proveedor
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        _debounce?.cancel();
        context.read<SearchProvider>().clearSearch(); // Borra el estado al cerrar definitivamente
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      context.read<SearchProvider>().updateQuery(query);
    }
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchProvider = context.read<SearchProvider>();

    if (query != searchProvider.query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchProvider.updateQuery(query);
      });
    }

    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        
        if (searchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No se encontraron resultados para: "$query"',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: searchProvider.searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,         
            crossAxisSpacing: 12,      
            mainAxisSpacing: 15,       
            childAspectRatio: 0.65,    
          ),
          itemBuilder: (context, index) {
            final movie = searchProvider.searchResults[index];
            
            return GestureDetector(
              onTap: () {
                _debounce?.cancel(); 
                // 💡 SOLUCIÓN 2: Al seleccionar una película, NO borramos el estado.
                // Solo cerramos devolviendo la película para que la persistencia se mantenga al navegar.
                close(context, movie);
              },
              child: MovieCardWidget(
                title: movie.title,
                imageUrl: movie.posterPath,
                rating: movie.voteAverage,
              ),
            ); 
          },
        );
      },
    );
  }
}