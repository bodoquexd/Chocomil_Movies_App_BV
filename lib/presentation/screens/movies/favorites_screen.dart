import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Obtenemos todo el provider
    final movieProvider = Provider.of<MovieProvider>(context);
    
    // 2. Juntamos todas las películas para que busque en todas las categorías
    final allMovies = [
      ...movieProvider.trendingMovies,
      ...movieProvider.actionMovies,
      ...movieProvider.sciFiMovies,
      ...movieProvider.comedyMovies,
      ...movieProvider.animationMovies,
    ];

    // 3. Quitamos duplicados por si una película se repite en varias listas
    final uniqueMovies = {for (var movie in allMovies) movie.id: movie}.values.toList();

    // 4. Filtramos preguntándole al provider si el ID de la película es favorito
    final favoriteMovies = uniqueMovies.where((m) => movieProvider.isFavorite(m.id)).toList();

    return Scaffold(
      // Mantenemos tu AppBar exactamente como estaba, sin colores forzados
      appBar: AppBar(title: const Text('Favoritos')),
      
      // Mantenemos el fondo por defecto
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Text('No has agregado favoritos aún.'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center, 
                  spacing: 16, 
                  runSpacing: 16, 
                  children: favoriteMovies.map((movie) {
                    return MovieCardWidget(movie: movie);
                  }).toList(),
                ),
              ),
            ),
    );
  }
}