import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors.dart';
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
                const Text(
                  'Hola! Regístrate para\nempezar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary, 
                    fontSize: 32, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 40),
                
                // Usando tu nuevo InputWidget
                const InputWidget(label: 'Nombre'),
                const SizedBox(height: 16),
                const InputWidget(label: 'Apellido'),
                const SizedBox(height: 16),
                const InputWidget(label: 'Correo Electrónico'),
                const SizedBox(height: 16),
                const InputWidget(label: 'Número de teléfono'),
                const SizedBox(height: 16),
                // Para las contraseñas, activamos tu propiedad obscureText
                const InputWidget(label: 'Contraseña', obscureText: true),
                const SizedBox(height: 16),
                const InputWidget(label: 'Confirmar contraseña', obscureText: true),
                
                const SizedBox(height: 40),
                
                // Usando tu nuevo ButtonWidget
                SizedBox(
                  width: double.infinity,
                  // El botón ahora es súper limpio de implementar
                  child: ButtonWidget(
                    texto: 'Crear cuenta',
                    onPressed: () => context.go('/'),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes cuenta? ', 
                      style: TextStyle(color: AppColors.textSecondary)
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Iniciar sesión', 
                        style: TextStyle(color: AppColors.textPrimary) 
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