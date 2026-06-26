import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';

import 'package:chocomil_movies_app_bv/presentation/widgets/search_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_row_section_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/featured_carousel_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.78);

    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      
      final movieProvider = context.read<MovieProvider>();
      if (movieProvider.featuredMovies.isEmpty) return;

      _currentPage = (_currentPage + 1) % movieProvider.featuredMovies.length;
      if (_featuredController.hasClients) {
        _featuredController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/icon_app.png', height: 45),
      ),
      body: movieProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.textPrimary),
            )
          : movieProvider.errorMessage != null
          ? Center(
              child: Text(
                movieProvider.errorMessage!,
                style: const TextStyle(color: Colors.white),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SearchWidget(),
                const SizedBox(height: 22),

                const SectionTitleWidget(title: 'Destacadas'),
                const SizedBox(height: 14),
                FeaturedCarouselWidget(
                  controller: _featuredController,
                  movies: movieProvider.featuredMovies,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(movieProvider.featuredMovies.length, (index) {
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
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),
                MovieRowSectionWidget(
                  title: 'Tendencias',
                  movies: movieProvider.trendingMovies,
                ),

                const SizedBox(height: 24),
                MovieRowSectionWidget(
                  title: 'Acción', 
                  movies: movieProvider.actionMovies
                ),

                const SizedBox(height: 24),
                MovieRowSectionWidget(
                  title: 'Ciencia ficción',
                  movies: movieProvider.sciFiMovies,
                ),

                const SizedBox(height: 24),
                MovieRowSectionWidget(
                  title: 'Comedia', 
                  movies: movieProvider.comedyMovies
                ),

                const SizedBox(height: 24),
                MovieRowSectionWidget(
                  title: 'Animación',
                  movies: movieProvider.animationMovies,
                ),

                const SizedBox(height: 30),
                const SectionTitleWidget(title: 'Comentarios'),
                const SizedBox(height: 15),

                // 5. Los comentarios que ya tenías diseñados
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
              ],
            ),
    );
  }
}