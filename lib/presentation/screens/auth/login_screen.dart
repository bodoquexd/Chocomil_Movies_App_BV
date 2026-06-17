import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/config/constants/environment.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage(); 

  bool _isLoading = false;

  Future<void> _loginConServidor() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${Environment.apiUrl}/auth/login');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
//              'bypass-tunnel-reminder': 'true',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        await _storage.write(key: 'email', value: email);
        await _storage.write(key: 'password', value: password);
        await _storage.write(key: 'has_credentials', value: 'true');

        if (mounted) {
          context.go('/');
        }
      } else {
        if (mounted) {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Error al iniciar sesión'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo conectar con el servidor')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  Future<void> _authenticate(BuildContext context) async {
    String? hasCredentials = await _storage.read(key: 'has_credentials');
    
    if (hasCredentials != 'true') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Primero inicia sesión manualmente con correo y contraseña')),
        );
      }
      return;
    }

    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Autentícate para ingresar a Chocomil Movies',
        biometricOnly: true,
      );
    } catch (e) {
      return;
    }

    if (authenticated) {
      setState(() {
        _isLoading = true; 
      });

      try {
        String? email = await _storage.read(key: 'email');
        String? password = await _storage.read(key: 'password');

        final url = Uri.parse('${Environment.apiUrl}/auth/login');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'bypass-tunnel-reminder': 'true',
          },
          body: jsonEncode({'email': email, 'password': password}),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          if (context.mounted) { 
            context.go('/');
          }
        } else {
          if (context.mounted) { 
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Credenciales expiradas. Inicia sesión manualmente.')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error de red al iniciar con huella')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                InputWidget(
                  label: 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(height: screenSize.height * 0.02),
                InputWidget(
                  label: 'Contraseña',
                  obscureText: true,
                  controller: _passwordController,
                ),

                SizedBox(height: screenSize.height * 0.05),

                SizedBox(
                  width: 150,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ButtonWidget(
                          texto: 'Aceptar',
                          onPressed: _loginConServidor,
                        ),
                ),

                SizedBox(height: screenSize.height * 0.03),
                IconButton(
                  onPressed: () => _authenticate(context),
                  icon: const Icon(
                    Icons.fingerprint,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: screenSize.height * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta? ',
                      style: TextosEstilos.cuerpo.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
                        style: TextosEstilos.cuerpo.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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