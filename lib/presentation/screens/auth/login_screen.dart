import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '1077647994525-rri1suomsvfq6nehnav34lkdvqerkshi.apps.googleusercontent.com' : null,
    scopes: ['email'],
  );
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

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('${Environment.apiUrl}/auth/login');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final user = responseData['user'];

        await _storage.write(key: 'email', value: email);
        await _storage.write(key: 'password', value: password);
        await _storage.write(key: 'has_credentials', value: 'true');
        await _storage.write(key: 'token', value: responseData['token'] ?? '');
        await _storage.write(key: 'first_name', value: user['firstName'] ?? '');
        await _storage.write(key: 'last_name', value: user['lastName'] ?? '');
        await _storage.write(key: 'phone', value: user['phone'] ?? 'Teléfono no registrado');
        await _storage.write(key: 'avatar_url', value: user['avatarUrl'] ?? '');
        final fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
        await _storage.write(key: 'name', value: fullName);

        if (!mounted) return;
        context.go('/home');
      } else {
        if (!mounted) return;
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorData['message'] ?? 'Error al iniciar sesión'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo conectar con el servidor')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginConGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final String? firebaseIdToken = await userCredential.user?.getIdToken();
     
      final url = Uri.parse('${Environment.apiUrl}/auth/google-login');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': firebaseIdToken}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final user = responseData['user'];

        await _storage.write(key: 'email', value: user['email'] ?? googleUser.email);
        await _storage.write(key: 'token', value: responseData['token'] ?? '');
        await _storage.write(key: 'first_name', value: user['firstName'] ?? '');
        await _storage.write(key: 'last_name', value: user['lastName'] ?? '');
        await _storage.write(key: 'avatar_url', value: user['avatarUrl'] ?? '');
        await _storage.write(key: 'phone', value: 'Google SSO');
        await _storage.write(key: 'has_credentials', value: 'false');
        final fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
        await _storage.write(key: 'name', value: fullName);

        if (!mounted) return;
        context.go('/home');
      } else if (response.statusCode == 404) {
        if (!mounted) return;
        context.push(
          '/register',
          extra: {
            'email': googleUser.email,
            'name': googleUser.displayName?.split(' ').first ?? '',
            'last_name': googleUser.displayName?.split(' ').last ?? '',
          },
        );
      }
    } catch (e) {
      debugPrint("Error completo en Flutter: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al iniciar sesión con Google')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    final String? token = await _storage.read(key: 'token');

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero debes iniciar sesión de forma normal al menos una vez')),
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
        const SnackBar(content: Text('Error al interactuar con el sensor biométrico')),
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
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : ButtonWidget(
                          texto: 'Aceptar',
                          onPressed: _loginConServidor,
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
                      onPressed: _loginConGoogle,
                      icon: Image.asset('assets/images/google.png', width: 35),
                    ),

                    IconButton(
                      onPressed: () => _authenticate(context),
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