import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/search_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/featured_movie_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/footer_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/botton_nav_widget.dart';
import 'package:chocomil_movies_app_bv/infrastructure/services/movie_service.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _featuredController;
  
  // Instanciamos el servicio (Asegúrate de haber importado el archivo)
  final MovieService _movieService = MovieService();

  // Listas vacías que se llenarán con la API
  List<_FeaturedMovie> featuredMovies = [];
  List<_Movie> trendingMovies = [];
  List<_Movie> actionMovies = [];
  List<_Movie> sciFiMovies = [];

  // Variables de estado para manejar la carga y los errores
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.78);
    _loadAllMovies(); // Disparamos la petición HTTP al iniciar la pantalla
  }

  Future<void> _loadAllMovies() async {
    try {
      // Consumimos los endpoints
      final rawTrending = await _movieService.getTrending();
      final rawAction = await _movieService.getMoviesByGenre(28); // 28 = Acción
      final rawSciFi = await _movieService.getMoviesByGenre(878); // 878 = Ciencia Ficción

      setState(() {
        trendingMovies = rawTrending.map((m) => _Movie(
          title: m['title'] ?? m['name'] ?? 'Sin título',
          imageUrl: _movieService.getImageUrl(m['poster_path']),
          rating: (m['vote_average'] as num).toDouble(),
        )).toList();

        // Usamos el top 5 de tendencias para las películas destacadas
        featuredMovies = trendingMovies.take(5).map((m) => _FeaturedMovie(
          title: m.title,
          imageUrl: m.imageUrl,
        )).toList();

        actionMovies = rawAction.map((m) => _Movie(
          title: m['title'] ?? 'Sin título',
          imageUrl: _movieService.getImageUrl(m['poster_path']),
          rating: (m['vote_average'] as num).toDouble(),
        )).toList();

        sciFiMovies = rawSciFi.map((m) => _Movie(
          title: m['title'] ?? 'Sin título',
          imageUrl: _movieService.getImageUrl(m['poster_path']),
          rating: (m['vote_average'] as num).toDouble(),
        )).toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Hubo un problema al conectar con TMDB. Verifica tu API Key y conexión.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Chocomil Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/login');
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // Validamos el estado antes de pintar la lista
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SearchWidget(),
                    const SizedBox(height: 22),

                    const _SectionTitle(title: 'Destacadas'),
                    const SizedBox(height: 14),

                    SizedBox(
                      height: 390,
                      child: PageView.builder(
                        controller: _featuredController,
                        itemCount: featuredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = featuredMovies[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: FeaturedMovieWidget(
                                title: movie.title,
                                imageUrl: movie.imageUrl,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    _MovieRowSection(
                      title: 'Tendencias',
                      movies: trendingMovies,
                    ),

                    const SizedBox(height: 24),
                    _MovieRowSection(
                      title: 'Acción',
                      movies: actionMovies,
                    ),

                    const SizedBox(height: 24),
                    _MovieRowSection(
                      title: 'Ciencia ficción',
                      movies: sciFiMovies,
                    ),

                    const SizedBox(height: 30),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'Comentarios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const CommentWidget(
                      userName: 'Carlos',
                      rating: 4.8,
                      comment: 'Excelente aplicación, encontré rápidamente las películas que buscaba.',
                    ),

                    const CommentWidget(
                      userName: 'Ana',
                      rating: 5.0,
                      comment: 'Me encanta el diseño. Parece una plataforma profesional de streaming.',
                    ),

                    const CommentWidget(
                      userName: 'Miguel',
                      rating: 4.5,
                      comment: 'Las recomendaciones son muy buenas y la navegación es sencilla.',
                    ),

                    const CommentWidget(
                      userName: 'Sofía',
                      rating: 4.9,
                      comment: 'La interfaz es moderna y muy agradable visualmente.',
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
      bottomNavigationBar: const BottomNavWidget(
        currentIndex: 0,
      ),
    );
  }
}

class _MovieRowSection extends StatelessWidget {
  final String title;
  final List<_Movie> movies;

  const _MovieRowSection({
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 310,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCardWidget(
                title: movie.title,
                imageUrl: movie.imageUrl,
                rating: movie.rating,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Clases internas para manejar los datos
class _Movie {
  final String title;
  final String imageUrl;
  final double rating;

  const _Movie({
    required this.title,
    required this.imageUrl,
    required this.rating,
  });
}

class _FeaturedMovie {
  final String title;
  final String imageUrl;

  const _FeaturedMovie({
    required this.title,
    required this.imageUrl,
  });
}