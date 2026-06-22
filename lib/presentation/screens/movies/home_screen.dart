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
      final rawSciFi = await _movieService.getMoviesByGenre(
        878,
      );

      setState(() {
        trendingMovies = rawTrending
            .map(
              (m) => _Movie(
                title: m['title'] ?? m['name'] ?? 'Sin título',
                imageUrl: _movieService.getImageUrl(m['poster_path']),
                rating: (m['vote_average'] as num).toDouble(),
              ),
            )
            .toList();

        featuredMovies = trendingMovies
            .take(5) 
            .map((m) => _FeaturedMovie(title: m.title, imageUrl: m.imageUrl))
            .toList();

        actionMovies = rawAction
            .map(
              (m) => _Movie(
                title: m['title'] ?? 'Sin título',
                imageUrl: _movieService.getImageUrl(m['poster_path']),
                rating: (m['vote_average'] as num).toDouble(),
              ),
            )
            .toList();

        sciFiMovies = rawSciFi
            .map(
              (m) => _Movie(
                title: m['title'] ?? 'Sin título',
                imageUrl: _movieService.getImageUrl(m['poster_path']),
                rating: (m['vote_average'] as num).toDouble(),
              ),
            )
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Hubo un problema al conectar con TMDB. Verifica tu API Key y conexión.';
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
          ? const Center(child: CircularProgressIndicator(color: AppColors.textPrimary))
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
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
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(featuredMovies.length, (index) {
                    final isActive = index == _currentPage;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 10,
                      ),
                      width: isActive ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.textPrimary : Colors.white38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Tendencias', movies: trendingMovies),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Acción', movies: actionMovies),

                const SizedBox(height: 24),
                _MovieRowSection(title: 'Ciencia ficción', movies: sciFiMovies),

                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Comentarios',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const CommentWidget(
                  userName: 'Carlos',
                  rating: 4.8,
                  comment:
                      'Excelente aplicación, encontré rápidamente las películas que buscaba.',
                ),

                const CommentWidget(
                  userName: 'Ana',
                  rating: 5.0,
                  comment:
                      'Me encanta el diseño. Parece una plataforma profesional de streaming.',
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

                const SizedBox(height: 30),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 280, 
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
          color: AppColors.textPrimary,
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

  const _FeaturedMovie({required this.title, required this.imageUrl});
}