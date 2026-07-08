import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/movie_detail_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final watchlistMovies = movieProvider.watchlistMovies;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        children: [
          // Encabezado Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.brown[900],
            child: Text(
              "Mis Guardados",
              textAlign: TextAlign.center,
              style: TextosEstilos.titulo.copyWith(color: Colors.white, fontSize: 22),
            ),
          ),
          
          // Lista
          Expanded(
            child: watchlistMovies.isEmpty
                ? Center(child: Text("No tienes películas guardadas", style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: watchlistMovies.length,
                    itemBuilder: (context, index) {
                      final movie = watchlistMovies[index];
                      return Card(
                        color: AppColors.backgroundBlack,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(movie.posterPath, width: 55, fit: BoxFit.cover),
                          ),
                          title: Text(movie.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text("⭐ ${movie.voteAverage.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white70)),
                          trailing: IconButton(
                            icon: const Icon(Icons.bookmark, color: Colors.blue), // Icono de guardado
                            onPressed: () => movieProvider.toggleWatchlist(movie),
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}