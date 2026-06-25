/*import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return Center(
      child: Text('Buscando: $query'),
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Center(
      child: Text('Escribe una película'),
    );

  }
}*/
/*
import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
//import 'package:chocomil_movies_app_bv/presentation/search_provider.dart';
// 💡 IMPORTA AQUÍ TU WIDGET DE PELÍCULA (Ej: movie_card_widget.dart)
// import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  
  @override
  String get searchFieldLabel => 'Buscar películas...';

  // 1. Acciones del lado derecho de la barra (ej: Limpiar texto)
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

  // 2. Icono de navegación del lado izquierdo (ej: Botón de regresar)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        context.read<SearchProvider>().clearSearch();
        close(context, null); // Cierra el buscador sin retornar ninguna película
      },
    );
  }

  // 3. Lo que se muestra cuando el usuario presiona "Enter" o "Buscar" en el teclado
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  // 4. Lo que se muestra en tiempo real mientras el usuario escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    // Sincronizamos lo que escribe el usuario en el teclado nativo con nuestro Provider
    // Usamos WidgetsBinding para evitar conflictos de renderizado mientras se escribe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().updateQuery(query);
    });

    return _buildSearchResults(context);
  }

  // Método centralizado para construir la lista de películas encontradas
  Widget _buildSearchResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    if (searchProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
      return Center(
        child: Text('No se encontraron resultados para: "$query"'),
      );
    }

    return ListView.builder(
      itemCount: searchProvider.searchResults.length,
      itemBuilder: (context, index) {
        final movie = searchProvider.searchResults[index];
        
        // 💡 AQUÍ PUEDES REUTILIZAR TU PROPIO WIDGET PERSONALIZADO
        // Si quieres que luzca idéntico al resto de tu app, descomenta y usa tu widget:
        // return MovieCardWidget(movie: movie); 
        
        // Mientras tanto, usamos un ListTile por defecto para que pruebes que funciona:
        return ListTile(
          leading: movie.posterPath.isNotEmpty
              ? Image.network(movie.posterPath, width: 50, fit: BoxFit.cover)
              : const SizedBox(width: 50, child: Icon(Icons.movie)),
          title: Text(movie.title),
          subtitle: Text(
            movie.overview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, movie); // Cierra regresando la película seleccionada
          },
        );
      },
    );
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
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

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().updateQuery(query);
    });

    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    if (searchProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No se encontraron resultados para: "$query"'),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchProvider.searchResults.length,
      itemBuilder: (context, index) {
        final movie = searchProvider.searchResults[index];
        return MovieCardWidget(movie: movie); 
      },
    );
  }
}*/

/*
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

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().updateQuery(query);
    });

    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    if (searchProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No se encontraron resultados para: "$query"'),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchProvider.searchResults.length,
      itemBuilder: (context, index) {
        final movie = searchProvider.searchResults[index];
        
        // 💡 SOLUCIÓN AQUÍ: Pasamos las propiedades individuales que exige tu constructor
        return MovieCardWidget(
          title: movie.title,
          imageUrl: movie.posterPath,
          rating: movie.voteAverage,
        ); 
      },
    );
  }
}*/

/*
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

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().updateQuery(query);
    });

    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    if (searchProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No se encontraron resultados para: "$query"'),
        ),
      );
    }

    // 💡 CAMBIO CLAVE: Usamos GridView para envolver tus tarjetas de ancho fijo de 180px
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: searchProvider.searchResults.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // 2 columnas de películas
        crossAxisSpacing: 15,       // Espaciado horizontal
        mainAxisSpacing: 15,        // Espaciado vertical
        childAspectRatio: 0.65,     // Relación de aspecto ideal para el alto de tu tarjeta con Expanded
      ),
      itemBuilder: (context, index) {
        final movie = searchProvider.searchResults[index];
        
        return GestureDetector(
          onTap: () {
            close(context, movie); // Al hacer tap, cierra regresando la película
          },
          child: MovieCardWidget(
            title: movie.title,
            imageUrl: movie.posterPath,
            rating: movie.voteAverage,
          ),
        ); 
      },
    );
  }
}*/


/*
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

  // 💡 SE DISPARA AL DAR "ENTER" O "BUSCAR" EN EL TECLADO: Aquí se hace la petición pesada
  @override
  Widget buildResults(BuildContext context) {
    // Usamos postFrameCallback para evitar conflictos de renderizado al actualizar el estado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.trim().isNotEmpty) {
        context.read<SearchProvider>().updateQuery(query);
      }
    });
    return _buildSearchResults(context);
  }

  // 💡 SE DISPARA MIENTRAS SE ESCRIBE: Muestra de forma estable lo que ya está cargado sin parpadear
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    if (searchProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (searchProvider.searchResults.isEmpty && query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Presiona buscar para encontrar: "$query"'),
        ),
      );
    }

    // Usamos LayoutBuilder para que se adapte perfectamente a cualquier pantalla
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: searchProvider.searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,         // 3 columnas para que tus tarjetas de 180px queden compactas y elegantes
            crossAxisSpacing: 8,       // Espaciado horizontal reducido
            mainAxisSpacing: 12,       // Espaciado vertical
            childAspectRatio: 0.52,    // Proporción ideal para corregir el tamaño gigante y no deformar tu tarjeta
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
}*/

/*
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

  // 💡 AQUÍ SE PROCESA LA BÚSQUEDA REAL (SOLO AL DAR ENTER/LOGRAR CLIC EN LA LUPA DEL TECLADO)
  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.trim().isNotEmpty) {
        context.read<SearchProvider>().updateQuery(query);
      }
    });
    return _buildSearchResults(context);
  }

  // 💡 ADIÓS PARPADEO: Mientras el usuario escribe, no disparamos renderizados continuos
  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

  // Método centralizado que arma la grilla de resultados
  Widget _buildSearchResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

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
            'Presiona "Buscar" en el teclado para encontrar: "$query"',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      itemCount: searchProvider.searchResults.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,         // 💡 Ajustado a 4 columnas para que las imágenes sean más chicas y compactas
        crossAxisSpacing: 6,       // Espaciado horizontal reducido para las tarjetas pequeñas
        mainAxisSpacing: 10,        // Espaciado vertical entre filas
        childAspectRatio: 0.48,    // 💡 Relación de aspecto optimizada para el formato mini de tu tarjeta
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
  }
}*/

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