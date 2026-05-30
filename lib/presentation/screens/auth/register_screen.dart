import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/custom_text_field_widget.dart';
import 'package:chocomil_movies_app_bv/resources/colors.dart'; 

class RegisterScreen extends StatelessWidget {
  static const String name = 'register_screen';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Llamamos al color desde tu clase AppColors
      backgroundColor: AppColors.background, 
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
                    color: AppColors.textWhite,
                    fontSize: 32, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 40),
                
                const CustomTextField(hintText: 'Nombre'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Apellido'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Correo Electronico'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Numero de telefono'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Contraseña', isPassword: true),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Confirmar contraseña', isPassword: true),
                
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBlack // Usando el color centralizado
                    ),
                    child: const Text(
                      'Crear cuenta', 
                      style: TextStyle(color: AppColors.textAccent) // Usando el color centralizado
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes cuenta?', 
                      style: TextStyle(color: AppColors.textAccent) // Usando el color centralizado
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: const Text(
                        'iniciar sesión', 
                        style: TextStyle(color: AppColors.textWhite) // Usando el color centralizado
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}