import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';

class RegisterScreen extends StatelessWidget {
  static const String name = 'register_screen';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'Hola! Regístrate para\nempezar',
                  textAlign: TextAlign.center,
                  style: TextosEstilos.titulo,
                ),
                const SizedBox(height: 40),

                const InputWidget(label: 'Nombre'),
                const SizedBox(height: 16),
                const InputWidget(label: 'Apellido'),
                const SizedBox(height: 16),
                const InputWidget(
                  label: 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const InputWidget(
                  label: 'Número de teléfono',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                const InputWidget(label: 'Contraseña', obscureText: true),
                const SizedBox(height: 16),
                const InputWidget(
                  label: 'Confirmar contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(texto: 'Crear Cuenta', onPressed: () {}),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta? ',
                      style: TextosEstilos.cuerpo.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Iniciar sesión',
                        style: TextosEstilos.cuerpo.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
