import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class PdfGeneratorService {
  static PdfColor _toPdfColor(Color color) {
    final argb = color.toARGB32(); 
    final r = (argb >> 16) & 0xff;
    final g = (argb >> 8) & 0xff;
    final b = (argb >> 0) & 0xff;
    return PdfColor.fromInt((r << 16) | (g << 8) | b);
  }

  static Future<void> generateAndShareMoviesPdf({
    required List<Movie> movies,
    String title = 'Mis Películas Guardadas',
    String filename = 'mis_peliculas.pdf',
  }) async {
    final pdf = pw.Document();

    final font = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();
    final pdfBgColor = _toPdfColor(AppColors.primaryDark); 
    final pdfCardColor = _toPdfColor(AppColors.backgroundBlack); 
    final pdfAccentColor = _toPdfColor(AppColors.primaryLight); 
    final pdfTextColor = PdfColors.white; 
    final pdfTextMuted = PdfColors.grey400; 
    
    Uint8List? logoBytes;
    try {
      final logoData = await rootBundle.load('assets/images/icon_app.png');
      logoBytes = logoData.buffer.asUint8List();
    } catch (_) {
      logoBytes = null;
    }
    final Map<int, Uint8List?> posters = {};

    final downloadFutures = movies.map((movie) async {
      if (movie.posterPath.isEmpty) {
        posters[movie.id] = null;
        return;
      }

      String fullImageUrl = movie.posterPath;
      if (!fullImageUrl.startsWith('http')) {
        fullImageUrl = 'https://image.tmdb.org/t/p/w500$fullImageUrl';
      }

      try {
        final response = await http
            .get(Uri.parse(fullImageUrl))
            .timeout(const Duration(seconds: 4));

        if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
          posters[movie.id] = response.bodyBytes;
        } else {
          posters[movie.id] = null;
        }
      } catch (_) {
        posters[movie.id] = null;
      }
    });

    await Future.wait(downloadFutures);
    
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          buildBackground: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: pdfBgColor), 
            );
          },
        ),
        build: (pw.Context context) {
          return [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              margin: const pw.EdgeInsets.only(bottom: 20),
              decoration: pw.BoxDecoration(
                // 4. PASAMOS EL COLOR DIRECTAMENTE
                color: _toPdfColor(AppColors.primary),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoBytes != null) ...[
                    pw.Image(
                      pw.MemoryImage(logoBytes),
                      width: 45,
                      height: 45,
                      fit: pw.BoxFit.contain,
                    ),
                    pw.SizedBox(width: 14),
                  ],
                  pw.Column(
                    crossAxisAlignment: logoBytes != null
                        ? pw.CrossAxisAlignment.start
                        : pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        title,
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 18,
                          color: pdfTextColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Chocomil Movies App • Total: ${movies.length} películas',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ...movies.map((movie) {
              final posterBytes = posters[movie.id];

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfCardColor,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.ClipRRect(
                      horizontalRadius: 6,
                      verticalRadius: 6,
                      child: pw.Container(
                        width: 45,
                        height: 65,
                        color: _toPdfColor(AppColors.grayLight),
                        child: posterBytes != null && posterBytes.isNotEmpty
                            ? pw.Image(
                                pw.MemoryImage(posterBytes),
                                fit: pw.BoxFit.cover,
                              )
                            : pw.Center(
                                child: pw.Text(
                                  '?',
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    color: pdfTextMuted,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    pw.SizedBox(width: 14),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            movie.title,
                            style: pw.TextStyle(
                              font: fontBold,
                              color: pdfTextColor,
                              fontSize: 12,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              _buildStarSvg(size: 12, hexColor: '#D9822B'),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: pw.TextStyle(
                                  font: fontBold,
                                  color: pdfAccentColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ];
        },
      ),
    );

    if (kIsWeb) {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: filename,
      );
    } else {
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: filename,
      );
    }
  }

  static Future<void> generateAndShareFavoritesPdf(List<Movie> favorites) async {
    await generateAndShareMoviesPdf(
      movies: favorites,
      title: 'Mis Películas Favoritas',
      filename: 'mis_peliculas_favoritas.pdf',
    );
  }

  static pw.Widget _buildStarSvg({required double size, required String hexColor}) {
    final starSvgString = '''
    <svg width="24" height="24" viewBox="0 0 24 24" fill="$hexColor">
      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
    </svg>
    ''';
    return pw.SvgImage(
      svg: starSvgString,
      width: size,
      height: size,
    );
  }
}