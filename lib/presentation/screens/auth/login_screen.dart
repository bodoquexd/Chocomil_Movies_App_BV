import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _hacerLoginNormal() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final exito = await authProvider.loginConServidor(email, password);

    if (!mounted) return;

    if (exito) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Error al iniciar sesión'),
        ),
      );
    }
  }

  Future<void> _hacerLoginConGoogle() async {
    final authProvider = context.read<AuthProvider>();
    final resultado = await authProvider.loginConGoogle();

    if (!mounted) return;

    if (resultado['status'] == 'success') {
      context.go('/home');
    } else if (resultado['status'] == 'needs_registration') {
      context.push(
        '/register',
        extra: {
          'email': resultado['email'],
          'name': resultado['name'],
          'last_name': resultado['last_name'],
        },
      );
    } else if (resultado['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Error al iniciar sesión con Google',
          ),
        ),
      );
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final tieneSesion = await authProvider.checkSesionActiva();

    if (!mounted) return;

    if (!tieneSesion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Primero debes iniciar sesión de forma normal al menos una vez',
          ),
        ),
      );
      return;
    }

    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Autentícate para ingresar a Chocomil Movies',
      );

      if (!mounted) return;

      if (authenticated) {
        context.go('/home');
      }
    } catch (e) {
      debugPrint('Error de autenticación biométrica: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al interactuar con el sensor biométrico'),
        ),
      );
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
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.02),

                // LOGO
                Image.asset(
                  'assets/images/logo.png',
                  height: screenSize.height * 0.20,
                  fit: BoxFit.contain,
                ),

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

                const SizedBox(height: 16),

                InputWidget(
                  label: 'Contraseña',
                  obscureText: true,
                  controller: _passwordController,
                ),

                SizedBox(height: screenSize.height * 0.04),

                SizedBox(
                  width: 200,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : ButtonWidget(
                          texto: 'Aceptar',
                          onPressed: _hacerLoginNormal,
                        ),
                ),

                const SizedBox(height: 24),

                // SECCIÓN: ¿NO TIENES CUENTA? REGÍSTRATE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta? ',
                      style: TextosEstilos.cuerpo.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        'Regístrate',
                        style: TextosEstilos.cuerpo.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // SECCIÓN: O INICIA SESIÓN CON...
                Text(
                  'O inicia sesión con',
                  style: TextosEstilos.cuerpo.copyWith(
                    color: AppColors.textHint,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 10),

                // ICONOS: GOOGLE Y HUELLA
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      // Evitamos múltiples peticiones si ya está cargando
                      onPressed: isLoading ? null : _hacerLoginConGoogle,
                      icon: Image.asset('assets/images/google.png', width: 35),
                    ),

                    IconButton(
                      // Evitamos usar biometría si ya está procesando una solicitud
                      onPressed: isLoading
                          ? null
                          : () => _authenticate(context),
                      icon: const Icon(
                        Icons.fingerprint,
                        size: 50,
                        color: AppColors.primary,
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
