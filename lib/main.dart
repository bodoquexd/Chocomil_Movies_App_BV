import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/theme/app_theme.dart';
import 'package:chocomil_movies_app_bv/config/router/app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //.router hace que cabie su forma de navegacion a una mas mmoderna es un manejo automatico de rutas
    return MaterialApp.router(
      routerConfig: appRouter,//Sistema de rutas de la App
      debugShowCheckedModeBanner: false,
      title: 'My Movies App',
      theme: AppTheme().getTheme(),
    );
  }
}