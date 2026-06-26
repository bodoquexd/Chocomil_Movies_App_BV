import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  
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
        context.read<SearchProvider>().clearSearch();
        close(context, null);
      },
    );
  }

  // Al presionar Enter en el teclado, disparamos la petición HTTP de manera limpia
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      // Usamos read en lugar de watch para evitar ciclos infinitos de reconstrucción
      context.read<SearchProvider>().updateQuery(query);
    }
    return _buildSearchResults();
  }

  // Mientras escribe, dejamos la pantalla en blanco o estática para congelar el parpadeo
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  // Widget optimizado con Consumer aislado para controlar los tamaños y el parpadeo
  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        
        // 1. Si está cargando, mostramos la barra sin destruir el fondo
        if (searchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        // 2. Si no hay resultados
        if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Presiona la lupa del teclado para buscar: "$query"',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // 3. Cuadrícula ultra compacta con imágenes pequeñas (4 columnas)
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          itemCount: searchProvider.searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,         // 4 columnas = Tarjetas pequeñas y estilizadas
            crossAxisSpacing: 6,       // Espacio lateral mini
            mainAxisSpacing: 8,        // Espacio inferior mini
            childAspectRatio: 0.46,    // Proporción vertical perfecta para que no se deformen por ser chicas
          ),
          itemBuilder: (context, index) {
            final movie = searchProvider.searchResults[index];
            
            return GestureDetector(
              onTap: () {
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