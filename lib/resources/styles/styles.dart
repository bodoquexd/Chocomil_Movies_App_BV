import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chocomil_movies_app_bv/resources/colors.dart';

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
}