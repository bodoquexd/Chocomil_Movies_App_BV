

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/search_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/featured_movie_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/movie_card_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/comment_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _featuredController;

  final List<_FeaturedMovie> featuredMovies = const [
    _FeaturedMovie(
      title: 'Blade Runner 2049',
      imageUrl:
          'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg',
    ),
    _FeaturedMovie(
      title: 'Spider-Man: No Way Home',
      imageUrl:
          'https://image.tmdb.org/t/p/w500/5weKu49pzJCt06OPpjvT80efnQj.jpg',
    ),
    _FeaturedMovie(
      title: 'Top Gun: Maverick',
      imageUrl:
          'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
    ),
    _FeaturedMovie(
      title: 'The Batman',
      imageUrl:
          'https://picsum.photos/seed/thebatman/500/750',
    ),
    _FeaturedMovie(
      title: 'Avatar',
      imageUrl:
          'https://picsum.photos/seed/avatar/500/750',
    ),
  ];

  final List<_Movie> trendingMovies = const [
    _Movie(
      title: 'Blade Runner 2049',
      imageUrl:
          'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg',
      rating: 8.5,
    ),
    _Movie(
      title: 'Spider-Man: No Way Home',
      imageUrl:
          'https://image.tmdb.org/t/p/w500/5weKu49pzJCt06OPpjvT80efnQj.jpg',
      rating: 8.8,
    ),
    _Movie(
      title: 'Top Gun: Maverick',
      imageUrl:
          'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      rating: 8.9,
    ),
    _Movie(
      title: 'The Boys',
      imageUrl:
          'https://picsum.photos/seed/theboys/500/750',
      rating: 9.0,
    ),
    _Movie(
      title: 'The Greatest Showman',
      imageUrl:
          'https://picsum.photos/seed/showman/500/750',
      rating: 8.2,
    ),
    _Movie(
      title: 'Batman',
      imageUrl:
          'https://picsum.photos/seed/batman/500/750',
      rating: 9.1,
    ),
    _Movie(
      title: 'Deadpool',
      imageUrl:
          'https://picsum.photos/seed/deadpool/500/750',
      rating: 8.7,
    ),
    _Movie(
      title: 'Dune',
      imageUrl:
          'https://picsum.photos/seed/dune/500/750',
      rating: 9.0,
    ),
  ];

  final List<_Movie> actionMovies = const [
    _Movie(
      title: 'John Wick',
      imageUrl:
          'https://picsum.photos/seed/johnwick/500/750',
      rating: 8.9,
    ),
    _Movie(
      title: 'Mission Impossible',
      imageUrl:
          'https://picsum.photos/seed/missionimpossible/500/750',
      rating: 8.6,
    ),
    _Movie(
      title: 'The Dark Knight',
      imageUrl:
          'https://picsum.photos/seed/darkknight/500/750',
      rating: 9.2,
    ),
    _Movie(
      title: 'Fast X',
      imageUrl:
          'https://picsum.photos/seed/fastx/500/750',
      rating: 7.8,
    ),
    _Movie(
      title: 'Black Panther',
      imageUrl:
          'https://picsum.photos/seed/blackpanther/500/750',
      rating: 8.4,
    ),
    _Movie(
      title: 'Thor Ragnarok',
      imageUrl:
          'https://picsum.photos/seed/thor/500/750',
      rating: 8.3,
    ),
    _Movie(
      title: 'Iron Man',
      imageUrl:
          'https://picsum.photos/seed/ironman/500/750',
      rating: 8.0,
    ),
    _Movie(
      title: 'Deadpool 2',
      imageUrl:
          'https://picsum.photos/seed/deadpool2/500/750',
      rating: 8.4,
    ),
  ];

  final List<_Movie> sciFiMovies = const [
    _Movie(
      title: 'Interstellar',
      imageUrl:
          'https://picsum.photos/seed/interstellar/500/750',
      rating: 9.5,
    ),
    _Movie(
      title: 'Avatar: The Way of Water',
      imageUrl:
          'https://picsum.photos/seed/avatar2/500/750',
      rating: 8.7,
    ),
    _Movie(
      title: 'Oppenheimer',
      imageUrl:
          'https://picsum.photos/seed/oppenheimer/500/750',
      rating: 9.1,
    ),
    _Movie(
      title: 'The Matrix',
      imageUrl:
          'https://picsum.photos/seed/matrix/500/750',
      rating: 9.0,
    ),
    _Movie(
      title: 'Star Wars',
      imageUrl:
          'https://picsum.photos/seed/starwars/500/750',
      rating: 8.8,
    ),
    _Movie(
      title: 'Guardians of the Galaxy',
      imageUrl:
          'https://picsum.photos/seed/guardians/500/750',
      rating: 8.5,
    ),
    _Movie(
      title: 'Alien',
      imageUrl:
          'https://picsum.photos/seed/alien/500/750',
      rating: 8.9,
    ),
    _Movie(
      title: 'Arrival',
      imageUrl:
          'https://picsum.photos/seed/arrival/500/750',
      rating: 8.6,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.78);
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
      body: ListView(
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
            separatorBuilder: (_, __) => const SizedBox(width: 12),
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