import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _cargarDatosDeUsuario();
  }

  Future<void> _cargarDatosDeUsuario() async {
    final email = await _storage.read(key: 'email') ?? 'Correo no disponible';
    final nombre = await _storage.read(key: 'name') ?? 'Usuario de Chocomil';
    final telefono = await _storage.read(key: 'phone') ?? 'Teléfono no registrado';

    setState(() {
      _email = email;
      _nombre = nombre;
      _telefono = telefono;
    });
  }

  Future<void> _cerrarSesion() async {
    await _storage.deleteAll();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.cardBackground, // Usamos el fondo oscuro de tu app
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Mi Perfil', style: TextosEstilos.titulo),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenSize.height * 0.04),

              // --- FOTO DE PERFIL (Icono por defecto) ---
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Icon(
                  Icons.person,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              
              SizedBox(height: screenSize.height * 0.02),

              // --- NOMBRE DEL USUARIO ---
              Text(
                _nombre,
                style: TextosEstilos.titulo.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenSize.height * 0.05),

              // --- TARJETA CON LOS DATOS ---
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Fila del Correo
                    ListTile(
                      leading: const Icon(Icons.email, color: AppColors.primary),
                      title: Text('Correo Electrónico', style: TextosEstilos.cuerpo.copyWith(color: AppColors.textSecondary)),
                      subtitle: Text(_email, style: TextosEstilos.cuerpo),
                    ),
                    const Divider(color: AppColors.background, height: 1),
                    // Fila del Teléfono
                    ListTile(
                      leading: const Icon(Icons.phone, color: AppColors.primary),
                      title: Text('Teléfono', style: TextosEstilos.cuerpo.copyWith(color: AppColors.textSecondary)),
                      subtitle: Text(_telefono, style: TextosEstilos.cuerpo),
                    ),
                  ],
                ),
              ),

              const Spacer(), // Empuja el botón hacia abajo

              // --- BOTÓN DE CERRAR SESIÓN ---
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
    );
  }
}