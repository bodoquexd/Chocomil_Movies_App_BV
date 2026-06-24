import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/search_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/featured_movie_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';
import 'package:chocomil_movies_app_bv/infrastructure/services/movie_service.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _featuredController;
  Timer? _carouselTimer;
  int _currentPage = 0;
  final MovieService _movieService = MovieService();

  List<_FeaturedMovie> featuredMovies = [];
  List<_Movie> trendingMovies = [];
  List<_Movie> actionMovies = [];
  List<_Movie> sciFiMovies = [];
  List<_Movie> comedyMovies = [];
  List<_Movie> animationMovies = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.78);
    _loadAllMovies();

    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || featuredMovies.isEmpty) return;
      _currentPage = (_currentPage + 1) % featuredMovies.length;
      if (_featuredController.hasClients) {
        _featuredController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadAllMovies() async {
    try {
      final rawTrending = await _movieService.getTrending();
      final rawAction = await _movieService.getMoviesByGenre(28);
      final rawSciFi = await _movieService.getMoviesByGenre(878);
      final rawComedy = await _movieService.getMoviesByGenre(35);
      final rawAnimation = await _movieService.getMoviesByGenre(16);

      setState(() {
        List<_Movie> mapToMovie(List<dynamic> list) {
          return list
              .map(
                (m) => _Movie(
                  title: m['title'] ?? m['name'] ?? 'Sin título',
                  imageUrl: _movieService.getImageUrl(m['poster_path']),
                  rating: (m['vote_average'] as num).toDouble(),
                ),
              )
              .toList();
        }

        trendingMovies = mapToMovie(rawTrending);
        actionMovies = mapToMovie(rawAction);
        sciFiMovies = mapToMovie(rawSciFi);
        comedyMovies = mapToMovie(rawComedy);
        animationMovies = mapToMovie(rawAnimation);

        featuredMovies = trendingMovies
            .take(5)
            .map((m) => _FeaturedMovie(title: m.title, imageUrl: m.imageUrl))
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al conectar con TMDB. Revisa tu conexión.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
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
        title: Image.asset('assets/images/icon_app.png', height: 45),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.textPrimary),
            )
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
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
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final movie = featuredMovies[index];
                      return AnimatedBuilder(
                        animation: _featuredController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_featuredController.position.haveDimensions) {
                            value = _featuredController.page! - index;
                            value = (1 - (value.abs() * 0.35)).clamp(0.85, 1.0);
                          }
                          return Opacity(
                            opacity: value,
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                _MovieRowSection(title: 'Tendencias', movies: trendingMovies),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Acción', movies: actionMovies),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Ciencia ficción', movies: sciFiMovies),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Comedia', movies: comedyMovies),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Animación', movies: animationMovies),

                const SizedBox(height: 30),
                const _SectionTitle(title: 'Comentarios'),
                const SizedBox(height: 15),

                const CommentWidget(
                  userName: 'Carlos',
                  rating: 4.8,
                  comment:
                      'Excelente aplicación, encontré rápidamente las películas.',
                ),
                const CommentWidget(
                  userName: 'Elena',
                  rating: 4.7,
                  comment:
                      'La selección de películas de animación es increíble, ¡me encanta!',
                ),
                const CommentWidget(
                  userName: 'Ana',
                  rating: 5.0,
                  comment:
                      'Me encanta el diseño. Parece una plataforma profesional.',
                ),
                const CommentWidget(
                  userName: 'Miguel',
                  rating: 4.5,
                  comment:
                      'Las recomendaciones son muy buenas y la navegación es sencilla.',
                ),
                const CommentWidget(
                  userName: 'Sofía',
                  rating: 4.9,
                  comment:
                      'La interfaz es moderna y muy agradable visualmente.',
                ),

                const SizedBox(height: 40),
              ],
            ),
    );
  }
}

class _MovieRowSection extends StatelessWidget {
  final String title;
  final List<_Movie> movies;

  const _MovieRowSection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: title),
        const SizedBox(height: 14),
        
        // EL TRUCO: Envolver todo el carrusel en un ShaderMask
        ShaderMask(
          // 1. Configuramos el gradiente horizontal para el desvanecido
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              // Paradas de color: [transparente, opaco, opaco, transparente]
              // Ajusta los números 0.05 y 0.95 para cambiar la anchura del desvanecido.
              // A menor diferencia, bordes de desvanecido más estrechos.
              stops: const [0.0, 0.05, 0.95, 1.0], 
              colors: [
                Colors.transparent,
                Colors.white, // Usamos blanco como base opaca para la máscara
                Colors.white,
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          // 2. Este modo de mezcla 'dstIn' es clave para que la máscara afecte la opacidad
          blendMode: BlendMode.dstIn,
          
          child: SizedBox(
            height: 300, // Altura aumentada para evitar overflow (como configuramos antes)
            child: ListView.separated(
              // 3. Pequeño padding horizontal para mejor estética
              padding: const EdgeInsets.symmetric(horizontal: 4), 
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
  const _FeaturedMovie({required this.title, required this.imageUrl});
}
