import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores principales basados en la imagen
    const Color backgroundColor = Color(0xFF3B302B);
    const Color textColorAccent = Color(0xFFC78458);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Título principal
                    const Text(
                      'Hola! Regístrate para\nempezar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Campos de texto
                    _buildTextField('Nombre'),
                    const SizedBox(height: 16),
                    _buildTextField('Apellido'),
                    const SizedBox(height: 16),
                    _buildTextField('Correo Electronico'),
                    const SizedBox(height: 16),
                    _buildTextField('Numero de telefono'),
                    const SizedBox(height: 16),
                    _buildTextField('Contraseña', isPassword: true),
                    const SizedBox(height: 16),
                    _buildTextField('Confirmar contraseña', isPassword: true),
                    
                    const SizedBox(height: 40),
                    
                    // Botón de "Crear cuenta"
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para crear cuenta
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Fondo negro
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            color: textColorAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Texto inferior "¿Ya tienes cuenta? iniciar sesión"
                    RichText(
                      text: const TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: TextStyle(
                          color: textColorAccent,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Espaciado final inferior
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Método auxiliar para construir los campos de texto y mantener el código limpio
  Widget _buildTextField(String hintText, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFC78458), // Color marrón claro para el texto de hint
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Sin bordes
        ),
      ),
    );
  }
}