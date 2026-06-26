import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String comment;
  final double rating;

  const CommentWidget({
    super.key,
    required this.userName,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundBlack, 
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.person, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userName,
                    style: TextosEstilos.subtitulo.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.star,
                  color: AppColors.primaryLight,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: TextosEstilos.cuerpo,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              comment,
              style: TextosEstilos.cuerpo.copyWith(
                color: AppColors.grayLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}