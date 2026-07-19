import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Importado como en el home_screen

import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/config/constants/environment.dart';

class ProfileScreen extends StatefulWidget {
  static const String name = 'profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();

  String _nombre = 'Cargando...';
  String _email = 'Cargando...';
  String _telefono = 'Cargando...';
  String? _avatarUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosDeUsuario();
    _initAvatares(); // Llamada al provider, idéntico al home_screen
  }

  // Delegamos la petición a TMDB al Provider
  Future<void> _initAvatares() async {
    if (mounted) {
      context.read<MovieProvider>().loadAvatars();
    }
  }

  Future<void> _cargarDatosDeUsuario() async {
    final email = await _storage.read(key: 'email') ?? 'Correo no disponible';
    String? firstName = await _storage.read(key: 'first_name');
    String? lastName = await _storage.read(key: 'last_name');

    String nombreCompleto = '';
    if (firstName != null && firstName.isNotEmpty) {
      nombreCompleto = firstName;
      if (lastName != null && lastName.isNotEmpty) {
        nombreCompleto += ' $lastName';
      }
    } else {
      nombreCompleto = await _storage.read(key: 'name') ?? 'Usuario';
    }

    final telefono =
        await _storage.read(key: 'phone') ?? 'Teléfono no registrado';
    final avatar = await _storage.read(key: 'avatar_url');

    setState(() {
      _email = email;
      _nombre = nombreCompleto;
      _telefono = telefono;
      _avatarUrl = avatar;
    });
  }

  // Modificado para recibir String (URL) en lugar de File
  Future<void> _actualizarPerfilAPI({
    String? nuevoNombre,
    String? nuevaUrlAvatar,
  }) async {
    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: 'token');
      var uri = Uri.parse('${Environment.apiUrl}/auth/update-profile');
      var request = http.MultipartRequest('PUT', uri);

      request.headers['Authorization'] = 'Bearer $token';

      if (nuevoNombre != null) {
        request.fields['first_name'] = nuevoNombre.trim();
        request.fields['last_name'] = '';
      }

      // Ahora enviamos la URL del avatar predeterminado como texto
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

          setState(() => _nombre = nombreLimpio);
        }

        if (nuevaUrlAvatar != null || responseData['avatar_url'] != null) {
          String urlAvatar = responseData['avatar_url'] ?? nuevaUrlAvatar;
          if (urlAvatar.startsWith('/')) {
            final String baseOrigin = Uri.parse(Environment.apiUrl).origin;
            urlAvatar = '$baseOrigin$urlAvatar';
          }
          await _storage.write(key: 'avatar_url', value: urlAvatar);
          setState(() => _avatarUrl = urlAvatar);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado con éxito'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _mostrarSelectorDeAvatares() async {
    final avatarCategories = context.read<MovieProvider>().avatarCategories;

    if (avatarCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cargando avatares de sagas, intenta de nuevo en un segundo...',
          ),
        ),
      );
      return;
    }

    final String? avatarSeleccionado = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.backgroundBlack,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: Center(
                  child: Text(
                    'Elige tu Avatar',
                    style: TextosEstilos.titulo.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: avatarCategories.keys.length,
                  itemBuilder: (context, index) {
                    String nombreSaga = avatarCategories.keys.elementAt(index);
                    List<String> avatares = avatarCategories[nombreSaga]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            nombreSaga,
                            style: TextosEstilos.subtitulo.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: avatares.length,
                            itemBuilder: (context, avatarIndex) {
                              final url = avatares[avatarIndex];
                              return GestureDetector(
                                onTap: () => Navigator.pop(context, url),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryDark,
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (
                                            context,
                                            child,
                                            progress,
                                          ) => progress == null
                                          ? child
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primary,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (avatarSeleccionado != null && avatarSeleccionado != _avatarUrl) {
      await _actualizarPerfilAPI(nuevaUrlAvatar: avatarSeleccionado);
    }
  }

  Future<void> _editarNombreCompleto() async {
    TextEditingController nombreController = TextEditingController(
      text: _nombre,
    );

    final String? nuevoNombre = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryDark,
          title: Text('Apodo o Nombre', style: TextosEstilos.subtitulo),
          content: TextField(
            controller: nombreController,
            style: TextosEstilos.cuerpo,
            decoration: const InputDecoration(
              hintText: 'ej.',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(
                'Cancelar',
                style: TextosEstilos.boton.copyWith(color: AppColors.grayLight),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, nombreController.text.trim()),
              child: Text('Guardar', style: TextosEstilos.boton),
            ),
          ],
        );
      },
    );

    if (nuevoNombre != null &&
        nuevoNombre.isNotEmpty &&
        nuevoNombre != _nombre) {
      await _actualizarPerfilAPI(nuevoNombre: nuevoNombre);
    }
  }

  Future<void> _cerrarSesion() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Cerrar Sesión',
            style: TextosEstilos.subtitulo.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextosEstilos.cuerpo,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextosEstilos.boton.copyWith(color: AppColors.grayLight),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Sí, salir', style: TextosEstilos.boton),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        debugPrint('Error: $e');
      }
      await _storage.deleteAll();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 65,
        title: Image.asset(
          'assets/images/icon_app.png',
          height: 58,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: SectionTitleWidget(title: 'Mi Perfil'),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.06,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.height * 0.02),

                    GestureDetector(
                      onTap: _isLoading ? null : _mostrarSelectorDeAvatares,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child:
                                  (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                                  ? Image.network(
                                      _avatarUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (
                                            context,
                                            child,
                                            progress,
                                          ) => progress == null
                                          ? child
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.person,
                                                size: 80,
                                                color: AppColors.primary,
                                              ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 80,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ),
                          if (_isLoading)
                            const Positioned.fill(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            _nombre,
                            style: TextosEstilos.titulo.copyWith(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: _isLoading ? null : _editarNombreCompleto,
                        ),
                      ],
                    ),

                    SizedBox(height: screenSize.height * 0.03),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundBlack,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: AppColors.primary,
                            ),
                            title: Text(
                              'Correo Electrónico',
                              style: TextosEstilos.cuerpo.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              _email,
                              style: TextosEstilos.cuerpo.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white12, height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: AppColors.primary,
                            ),
                            title: Text(
                              'Teléfono',
                              style: TextosEstilos.cuerpo.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              _telefono,
                              style: TextosEstilos.cuerpo.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonWidget(
                        texto: 'Cerrar Sesión',
                        onPressed: _cerrarSesion,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
