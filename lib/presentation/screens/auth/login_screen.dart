import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen'; 
  
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.cardBackground, 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.05),
                Image.asset(
                  'assets/images/logo.png', 
                  height: screenSize.height * 0.22,
                  fit: BoxFit.contain,
                ),
                
                SizedBox(height: screenSize.height * 0.03),
                
                Text(
                  'Iniciar sesión',
                  style: TextosEstilos.titulo.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),

                const InputWidget(label: 'Correo Electrónico'),
                SizedBox(height: screenSize.height * 0.02), 
                const InputWidget(label: 'Contraseña', obscureText: true),
                SizedBox(height: screenSize.height * 0.05),

                SizedBox(
                  width: 150, 
                  child: ButtonWidget(
                    texto: 'Aceptar',
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta? ',
                      style: TextosEstilos.cuerpo.copyWith(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'), 
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Regístrate',
                        style: TextosEstilos.cuerpo.copyWith(fontWeight: FontWeight.bold), 
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}