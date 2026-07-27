import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class CustomErrorWidget extends StatelessWidget {
  final String imagePath; 
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 150, 
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextosEstilos.tituloMediano,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextosEstilos.cuerpo.copyWith(
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onRetry,
              child: Text(
                buttonText,
                style: TextosEstilos.boton.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}