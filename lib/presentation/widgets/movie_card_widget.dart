import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class MovieCardWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;

  const MovieCardWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180, 
      child: Card(
        elevation: 8,
        color: AppColors.backgroundBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover, 
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary,
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.textPrimary,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 75, 
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye el título y las estrellas
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextosEstilos.cuerpo.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.primaryLight,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextosEstilos.cuerpo.copyWith(
                            color: AppColors.grayLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}