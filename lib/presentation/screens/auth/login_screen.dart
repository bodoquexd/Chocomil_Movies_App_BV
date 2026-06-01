import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:chocomil_movies_app_bv/resources/colors.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos el fondo oscuro de chocolate
      backgroundColor: AppColors.cardBackground,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const SizedBox(height: 60),

                //========================
                // LOGO
                //========================
                SizedBox(
                  width: double.infinity,

                  child: Image.asset(
                    'assets/images/logo.png',

                    height: 440,

                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                //========================
                // TITULO
                //========================
                const Text(
                  'Iniciar sesión',

                  style: TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 32,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                //========================
                // INPUT EMAIL
                //========================
                const InputWidget(label: 'Correo Electrónico'),

                const SizedBox(height: 20),

                //========================
                // INPUT PASSWORD
                //========================
                const InputWidget(label: 'Contraseña', obscureText: true),

                const SizedBox(height: 40),

                //========================
                // BOTON
                //========================
                SizedBox(
                  width: 150,

                  child: ButtonWidget(texto: 'Aceptar', onPressed: () {}),
                ),

                const SizedBox(height: 40),

                //========================
                // REGISTER
                //========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      '¿No tienes una cuenta? ',

                      style: TextStyle(color: AppColors.textSecondary),
                    ),

                    TextButton(
                      onPressed: () => context.push('/register'),

                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,

                        minimumSize: Size.zero,

                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),

                      child: const Text(
                        'Regístrate',

                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
