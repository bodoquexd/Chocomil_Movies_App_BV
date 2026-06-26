import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;

  const SectionTitleWidget({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextosEstilos.titulo.copyWith(
          fontSize: 22,
        ),
      ),
    );
  }
}