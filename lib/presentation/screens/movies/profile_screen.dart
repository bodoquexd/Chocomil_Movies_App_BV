import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:chocomil_movies_app_bv/providers/profile_provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_provider.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/profile_modals_widget.dart'; 

class ProfileScreen extends StatefulWidget {
  static const String name = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().cargarDatosDeUsuario();
      context.read<MovieProvider>().loadAvatars();
    });
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _handleAvatarSelection() async {
    final avatarCategories = context.read<MovieProvider>().avatarCategories;
    
    if (avatarCategories.isEmpty) {
      _showSnackbar('Cargando avatares, intenta de nuevo...', Colors.orange);
      return;
    }

    final avatarSeleccionado = await ProfileModals.showAvatarSelector(context, avatarCategories);
    if (avatarSeleccionado != null && mounted) {
      final success = await context.read<ProfileProvider>().actualizarPerfilAPI(nuevaUrlAvatar: avatarSeleccionado);
      _showSnackbar(success ? 'Avatar actualizado' : 'Error al actualizar', success ? Colors.green : Colors.red);
    }
  }

  Future<void> _handleNameEdit() async {
    final provider = context.read<ProfileProvider>();
    final nuevoNombre = await ProfileModals.showEditNameDialog(context, provider.nombre);
    
    if (nuevoNombre != null && nuevoNombre.isNotEmpty && nuevoNombre != provider.nombre && mounted) {
      final success = await context.read<ProfileProvider>().actualizarPerfilAPI(nuevoNombre: nuevoNombre);
      _showSnackbar(success ? 'Nombre actualizado' : 'Error al actualizar', success ? Colors.green : Colors.red);
    }
  }

  Future<void> _handleLogout() async {
    final confirmar = await ProfileModals.showLogoutDialog(context);
    if (confirmar == true && mounted) {
      await context.read<ProfileProvider>().cerrarSesion();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileProvider = context.watch<ProfileProvider>();
    final double avatarSize = (size.width * 0.35).clamp(100.0, 150.0);

    return Scaffold(
      resizeToAvoidBottomInset: true, 
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 65,
        title: Image.asset(
          'assets/images/icon_app.png', 
          height: 58, 
          fit: BoxFit.contain
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: SectionTitleWidget(title: 'Mi Perfil'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(), 
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                          child: Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.02),
                              
                              // Widget del Avatar
                              GestureDetector(
                                onTap: profileProvider.isLoading ? null : _handleAvatarSelection,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: avatarSize, 
                                      height: avatarSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.primary, width: 3),
                                      ),
                                      child: ClipOval(
                                        child: (profileProvider.avatarUrl != null)
                                            ? Image.network(
                                                profileProvider.avatarUrl!, 
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => 
                                                  Icon(Icons.person, size: avatarSize * 0.5, color: AppColors.primary),
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                },
                                              )
                                            : Icon(Icons.person, size: avatarSize * 0.5, color: AppColors.primary),
                                      ),
                                    ),
                                    if (profileProvider.isLoading)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black45,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(color: Colors.white)
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.all(avatarSize * 0.07),
                                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                      child: Icon(Icons.edit, color: Colors.white, size: avatarSize * 0.16),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: constraints.maxHeight * 0.02),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      profileProvider.nombre,
                                      style: TextosEstilos.titulo.copyWith(
                                        fontSize: (size.width * 0.06).clamp(18.0, 26.0), 
                                        color: Colors.white
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2, 
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white70, size: 22),
                                    onPressed: profileProvider.isLoading ? null : _handleNameEdit,
                                  ),
                                ],
                              ),

                              SizedBox(height: constraints.maxHeight * 0.03),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundBlack,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.email, color: AppColors.primary),
                                      title: Text('Correo Electrónico', style: TextosEstilos.cuerpo.copyWith(color: AppColors.textSecondary, fontSize: 13)),
                                      subtitle: Text(
                                        profileProvider.email, 
                                        style: TextosEstilos.cuerpo.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, 
                                      ),
                                    ),
                                    const Divider(color: Colors.white12, height: 1),
                                    ListTile(
                                      leading: const Icon(Icons.phone, color: AppColors.primary),
                                      title: Text('Teléfono', style: TextosEstilos.cuerpo.copyWith(color: AppColors.textSecondary, fontSize: 13)),
                                      subtitle: Text(
                                        profileProvider.telefono, 
                                        style: TextosEstilos.cuerpo.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: constraints.maxHeight * 0.05),
                              
                              SizedBox(
                                width: double.infinity,
                                child: ButtonWidget(texto: 'Cerrar Sesión', onPressed: _handleLogout),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.04), 
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}