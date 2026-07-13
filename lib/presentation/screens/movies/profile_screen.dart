import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart'; // NUEVA IMPORTACIÓN

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

  @override
  void initState() {
    super.initState();
    _cargarDatosDeUsuario();
  }

  Future<void> _cargarDatosDeUsuario() async {
    final email = await _storage.read(key: 'email') ?? 'Correo no disponible';
    String? nombre = await _storage.read(key: 'name');
    if (nombre == null) {
      final firstName = await _storage.read(key: 'first_name') ?? 'Usuario';
      final lastName = await _storage.read(key: 'last_name') ?? 'Chocomil';
      nombre = '$firstName $lastName'.trim();
    }

    final telefono =
        await _storage.read(key: 'phone') ?? 'Teléfono no registrado';
    final avatar = await _storage.read(key: 'avatar_url');

    setState(() {
      _email = email;
      _nombre = nombre!;
      _telefono = telefono;
      _avatarUrl = avatar;
    });
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
              child: Text(
                'Sí, salir',
                style: TextosEstilos.boton,
              ),
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
        debugPrint('Error al cerrar sesión de Google: $e');
      }
      await _storage.deleteAll();
      
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // 1. Fondo estandarizado
      backgroundColor: AppColors.primaryDark,
      
      // 2. AppBar unificado con el logo
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
            // 3. Título de Sección estilo Home
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: SectionTitleWidget(title: 'Mi Perfil'),
            ),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.height * 0.02),

                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                            ? Image.network(
                                _avatarUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: AppColors.primary,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.primary,
                              ),
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      _nombre,
                      style: TextosEstilos.titulo.copyWith(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenSize.height * 0.05),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundBlack, // Contraste ligero para los datos
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          // Fila del Correo
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
                            subtitle: Text(_email, style: TextosEstilos.cuerpo.copyWith(color: Colors.white)),
                          ),
                          const Divider(color: Colors.white12, height: 1),
                          // Fila del Teléfono
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
                            subtitle: Text(_telefono, style: TextosEstilos.cuerpo.copyWith(color: Colors.white)),
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