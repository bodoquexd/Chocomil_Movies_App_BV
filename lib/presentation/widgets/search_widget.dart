/*
import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

// IMPORTA TU SEARCH DELEGATE
import '../screens/movies/movie_search_delegate.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        showSearch(
          context: context,
          delegate: MovieSearchDelegate(),
        );

      },
      child: AbsorbPointer(
        child: TextField(
          style: TextosEstilos.cuerpo.copyWith(
            color: AppColors.primaryDark,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar película...',
            hintStyle: TextosEstilos.cuerpo.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import '../screens/movies/movie_search_delegate.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Leemos el texto guardado en memoria y se lo inyectamos al buscador
        final textoGuardado = context.read<SearchProvider>().query;

        showSearch(
          context: context,
          delegate: MovieSearchDelegate(),
          query: textoGuardado, 
        );
      },
      child: AbsorbPointer(
        child: TextField(
          style: TextosEstilos.cuerpo.copyWith(
            color: AppColors.primaryDark,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar película...',
            hintStyle: TextosEstilos.cuerpo.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import '../screens/movies/movie_search_delegate.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Recupera el texto que se quedó en memoria (si es que no se cerró con la flecha)
        final textoGuardado = context.read<SearchProvider>().query;

        showSearch(
          context: context,
          delegate: MovieSearchDelegate(),
          query: textoGuardado, // Inyecta el texto automáticamente al abrirse de nuevo
        );
      },
      child: AbsorbPointer(
        child: TextField(
          style: TextosEstilos.cuerpo.copyWith(
            color: AppColors.primaryDark,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar película...',
            hintStyle: TextosEstilos.cuerpo.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/providers/search_provider.dart';
import '../screens/movies/movie_search_delegate.dart';

// 💡 1. Convertimos a StatefulWidget para tener control del ciclo de vida (initState)
class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  @override
  void initState() {
    super.initState();

    // 💡 2. ESTA ES LA MAGIA: Al reconstruirse la pestaña Home, revisamos la memoria
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final textoGuardado = context.read<SearchProvider>().query;
      
      // Si hay texto guardado, significa que no cerraste el buscador con la flecha.
      // Por lo tanto, lo volvemos a abrir automáticamente de inmediato.
      if (textoGuardado.isNotEmpty) {
        showSearch(
          context: context,
          delegate: MovieSearchDelegate(),
          query: textoGuardado,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Apertura manual tradicional
        final textoGuardado = context.read<SearchProvider>().query;

        showSearch(
          context: context,
          delegate: MovieSearchDelegate(),
          query: textoGuardado, 
        );
      },
      child: AbsorbPointer(
        child: TextField(
          style: TextosEstilos.cuerpo.copyWith(
            color: AppColors.primaryDark,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar película...',
            hintStyle: TextosEstilos.cuerpo.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}