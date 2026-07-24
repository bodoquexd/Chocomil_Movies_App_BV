import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chocomil_movies_app_bv/config/constants/environment.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '1077647994525-rri1suomsvfq6nehnav34lkdvqerkshi.apps.googleusercontent.com' : null,
    scopes: ['email'],
  );

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static final nameRegex = RegExp(r'^[A-ZÁÉÍÓÚÑ][A-záéíóúñÁÉÍÓÚÑ\s]+$');
  static final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|outlook\.com|live\.com|icloud\.com|yahoo\.com)$');
  static final passwordRegex = RegExp(r'^(?=.*[A-Z]).{8,}$');

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _saveUserData(Map<String, dynamic> user, String token, bool hasCredentials) async {
    user['has_credentials'] = hasCredentials;
    user['full_name'] = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
    
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'user_data', value: jsonEncode(user));
  }

  // Método para el SplashScreen: Verifica si hay sesión
  Future<bool> checkSesionActiva() async {
    final token = await _storage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }
  Future<bool> loginConServidor(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final url = Uri.parse('${Environment.apiUrl}/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveUserData(data['user'], data['token'] ?? '', true);
        
        // Opcional: Si quieres guardar las credenciales para la huella dactilar
        await _storage.write(key: 'email', value: email);
        await _storage.write(key: 'password', value: password);
        
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _errorMessage = errorData['message'] ?? 'Error al iniciar sesión';
        return false;
      }
    } catch (e) {
      _errorMessage = 'No se pudo conectar con el servidor';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  Future<bool> registrarConServidor({
    required String nombre,
    required String apellido,
    required String email,
    required String telefono,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final url = Uri.parse('${Environment.apiUrl}/auth/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nombre,
          'last_name': apellido,
          'email': email,
          'phone': telefono,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _errorMessage = errorData['message'] ?? 'Error al registrar la cuenta';
        return false;
      }
    } catch (e) {
      _errorMessage = 'No se pudo conectar con el servidor';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> loginConGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return {'status': 'canceled'};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      final url = Uri.parse('${Environment.apiUrl}/auth/google-login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': firebaseIdToken}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        user['email'] = user['email'] ?? googleUser.email; 
        
        await _saveUserData(user, data['token'] ?? '', false);
        return {'status': 'success'};
      } 
      else if (response.statusCode == 404) {
        // Necesita registrarse
        return {
          'status': 'needs_registration',
          'email': googleUser.email,
          'name': googleUser.displayName?.split(' ').first ?? '',
          'last_name': googleUser.displayName?.split(' ').last ?? '',
        };
      } 
      else {
        _errorMessage = 'Error en el servidor al autenticar con Google';
        return {'status': 'error'};
      }
    } catch (e) {
      debugPrint("Error completo en Flutter: $e");
      _errorMessage = 'Error al iniciar sesión con Google';
      return {'status': 'error'};
    } finally {
      _setLoading(false);
    }
  }
  Future<void> logout() async {
    await _storage.deleteAll();
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    // notifyListeners(); // Si tuvieras datos del usuario en memoria
  }
}