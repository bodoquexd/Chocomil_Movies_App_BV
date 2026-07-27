import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class ProfileModals {
  // Modal para elegir Avatar
  static Future<String?> showAvatarSelector(
    BuildContext context,
    Map<String, List<String>> avatarCategories,
  ) {
    return showModalBottomSheet<String>(
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: Text(
                  'Elige tu Avatar',
                  style: TextosEstilos.titulo.copyWith(
                    color: Colors.white,
                    fontSize: 22,
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
                    return _buildSagaRow(context, nombreSaga, avatares);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSagaRow(
    BuildContext context,
    String nombreSaga,
    List<String> avatares,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            nombreSaga,
            style: TextosEstilos.subtitulo.copyWith(
              color: AppColors.primary,
              fontSize: 16,
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
            itemBuilder: (context, idx) {
              final url = avatares[idx];
              return GestureDetector(
                onTap: () => Navigator.pop(context, url),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) => progress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 2. Diálogo para editar el nombre
  static Future<String?> showEditNameDialog(
    BuildContext context,
    String currentName,
  ) {
    TextEditingController controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: Text('Apodo o Nombre', style: TextosEstilos.subtitulo),
        content: TextField(
          controller: controller,
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
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('Guardar', style: TextosEstilos.boton),
          ),
        ],
      ),
    );
  }

  //Diálogo de Cerrar Sesión
  static Future<bool?> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Cerrar Sesión',
          style: TextosEstilos.subtitulo.copyWith(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
