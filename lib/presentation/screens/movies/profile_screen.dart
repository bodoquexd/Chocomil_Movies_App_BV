import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class ProfileScreen extends StatelessWidget {
  static const String name = 'profile_screen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Text(
          'Perfil de usuario',
          style: TextosEstilos.titulo,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}