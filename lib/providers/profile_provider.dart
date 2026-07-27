import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chocomil_movies_app_bv/config/constants/environment.dart';

class ProfileProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  String nombre = 'Cargando...';
  String email = 'Cargando...';
  String telefono = 'Cargando...';
  String? avatarUrl;
  bool isLoading = false;

  Future<void> cargarDatosDeUsuario() async {
    email = await _storage.read(key: 'email') ?? 'Correo no disponible';
    String? firstName = await _storage.read(key: 'first_name');
    String? lastName = await _storage.read(key: 'last_name');

    if (firstName != null && firstName.isNotEmpty) {
      nombre =
          firstName +
          (lastName != null && lastName.isNotEmpty ? ' $lastName' : '');
    } else {
      nombre = await _storage.read(key: 'name') ?? 'Usuario';
    }

    telefono = await _storage.read(key: 'phone') ?? 'Teléfono no registrado';
    avatarUrl = await _storage.read(key: 'avatar_url');
    notifyListeners();
  }

  Future<bool> actualizarPerfilAPI({
    String? nuevoNombre,
    String? nuevaUrlAvatar,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      var uri = Uri.parse('${Environment.apiUrl}/auth/update-profile');
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (nuevoNombre != null) {
        request.fields['first_name'] = nuevoNombre.trim();
        request.fields['last_name'] = '';
      }
      if (nuevaUrlAvatar != null) {
        request.fields['avatar_url'] = nuevaUrlAvatar;
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (nuevoNombre != null) {
          final nombreLimpio = nuevoNombre.trim();
          await _storage.write(key: 'first_name', value: nombreLimpio);
          await _storage.write(key: 'last_name', value: '');
          await _storage.delete(key: 'name');
          nombre = nombreLimpio;
        }

        if (nuevaUrlAvatar != null || responseData['avatar_url'] != null) {
          String urlAvatar = responseData['avatar_url'] ?? nuevaUrlAvatar;
          if (urlAvatar.startsWith('/')) {
            final String baseOrigin = Uri.parse(Environment.apiUrl).origin;
            urlAvatar = '$baseOrigin$urlAvatar';
          }
          await _storage.write(key: 'avatar_url', value: urlAvatar);
          avatarUrl = urlAvatar;
        }

        isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error actualizando perfil: $e');
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> cerrarSesion() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        bool isGoogleUser = user.providerData.any(
          (provider) => provider.providerId == 'google.com',
        );
        if (isGoogleUser) {
          // Adaptado a v7.x: Se usa GoogleSignIn.instance y se asegura la inicialización
          final googleSignIn = GoogleSignIn.instance;
          await googleSignIn.initialize();
          await googleSignIn.signOut();
        }
      }
    } catch (e) {
      debugPrint('Error verificando/cerrando sesión de Google: $e');
    }
    await FirebaseAuth.instance.signOut();
    await _storage.deleteAll();
  }
}
