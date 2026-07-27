import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class TextosEstilos {

  static final titulo = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final subtitulo = GoogleFonts.inter(
    fontSize: 18,
    color: AppColors.textPrimary,
  );

  static final cuerpo = GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static final boton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );

  // Para el MovieDetailAppBarWidget
  static final tituloHero = GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.1,
  );

  // Para los nombres de los actores en CastSectionWidget
  static final etiqueta = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Para los personajes en el CastSectionWidget o subtítulos menores
  static final etiquetaSecundaria = GoogleFonts.inter(
    fontSize: 13,
    color: AppColors.textMuted,
  );

  // Variante para los títulos en CustomErrorWidget o FeaturedMovieWidget
  static final tituloMediano = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}