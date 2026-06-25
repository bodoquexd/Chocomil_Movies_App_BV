import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/theme/app_theme.dart';
import 'package:chocomil_movies_app_bv/config/router/app_router.dart';
import 'package:chocomil_movies_app_bv/domain/repositories/movie_repositories.dart';
import 'package:chocomil_movies_app_bv/infrastructure/datasources/movie_repository_impl.dart';
import 'package:chocomil_movies_app_bv/infrastructure/datasources/tmdb_datasource.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MovieRepositories>(
          create: (_) => MovieRepositoryImpl(TmdbDatasource()),
        ),
        
        ChangeNotifierProvider<MovieProvider>(
          create: (context) => MovieProvider(
            movieRepository: context.read<MovieRepositories>(),
          )..loadAllMovies(), 
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        title: 'My Movies App',
        theme: AppTheme().getTheme(),
      ),
    );
  }
}