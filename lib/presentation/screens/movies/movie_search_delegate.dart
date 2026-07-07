import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/custom_error_widget.dart';

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
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
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

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildDefaultMovies();
    }

    final searchProvider = context.read<SearchProvider>();

    if (query != searchProvider.query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchProvider.updateQuery(query);
      });
    }

    return _buildSearchResults();
  }

  Widget _buildDefaultMovies() {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        final defaultMovies = movieProvider.trendingMovies;

        if (defaultMovies.isEmpty) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: defaultMovies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final movie = defaultMovies[index];

            return GestureDetector(
              onTap: () {
                _debounce?.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: MovieCardWidget(movie: movie),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.isLoading) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
          return CustomErrorWidget(
            imagePath: 'assets/images/error_404.png',
            title: 'Película no encontrada',
            message: 'No encontramos ninguna película con el nombre "$query".',
            buttonText: 'Buscar otra',
            onRetry: () {
              query = '';
              context.read<SearchProvider>().clearSearch();
              showSuggestions(context);
            },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: MovieCardWidget(movie: movie),
            );
          },
        );
      },
    );
  }
}
