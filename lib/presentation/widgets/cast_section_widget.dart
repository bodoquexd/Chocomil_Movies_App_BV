import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';

class CastSectionWidget extends StatefulWidget {
  final List<dynamic> cast;

  const CastSectionWidget({super.key, required this.cast});

  @override
  State<CastSectionWidget> createState() => _CastSectionWidgetState();
}

class _CastSectionWidgetState extends State<CastSectionWidget> {
  bool _isCastExpanded = false;
  Future<Map<String, dynamic>> _fetchActorDetails(int actorId) async {
    final apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';
    try {
      final res = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/person/$actorId?api_key=$apiKey&language=es-MX'));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
    } catch (e) {
      debugPrint('Error obteniendo actor: $e');
    }
    return {};
  }

  void _showActorDetails(BuildContext context, dynamic actor) {
    final actorId = actor['id'];
    final profilePath = actor['profile_path'];
    final imageUrl = profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://via.placeholder.com/300x450.png?text=No+Image';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF151515), 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            height: 380, 
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen grande a la izquierda
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 130,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 130,
                      color: Colors.grey[800],
                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Detalles a la derecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor['name'] ?? 'Desconocido',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        actor['character'] ?? '',
                        style: const TextStyle(
                          color: Colors.orange, 
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(color: Colors.white24, height: 20),
                      
                      // Cargar datos extra del actor (Biografía, etc.)
                      Expanded(
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: _fetchActorDetails(actorId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(color: Colors.orange));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No hay más detalles disponibles.', style: TextStyle(color: Colors.white54));
                            }

                            final data = snapshot.data!;
                            final bio = data['biography']?.toString().isNotEmpty == true 
                                ? data['biography'] 
                                : 'Biografía no disponible en español.';
                            final birthday = data['birthday'] ?? 'Desconocido';
                            final placeOfBirth = data['place_of_birth'] ?? 'Desconocido';

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow('Nacimiento:', birthday),
                                  const SizedBox(height: 4),
                                  _buildDetailRow('Lugar:', placeOfBirth),
                                  const SizedBox(height: 12),
                                  const Text('Biografía:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(
                                    bio,
                                    style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Botón cerrar
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar', style: TextStyle(color: Colors.orange)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  // Widget auxiliar para las filas de texto del modal
  Widget _buildDetailRow(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$title ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          TextSpan(text: value, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Reparto Principal'),
        const SizedBox(height: 12),

        // Vista contraída (Horizontal)
        if (!_isCastExpanded)
          SizedBox(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.cast.length > 3 ? 4 : widget.cast.length,
              itemBuilder: (context, index) {
                // Botón "Ver más"
                if (index == 3) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCastExpanded = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      width: 85,
                      child: Column(
                        children: [
                          Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white70,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ver más',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Tarjetas de actores
                final actor = widget.cast[index];
                final profilePath = actor['profile_path'];
                final imageUrl = profilePath != null
                    ? 'https://image.tmdb.org/t/p/w200$profilePath'
                    : 'https://via.placeholder.com/150x150.png?text=No+Image';

                // --- SE AGREGÓ GestureDetector AQUÍ ---
                return GestureDetector(
                  onTap: () => _showActorDetails(context, actor),
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 85,
                    color: Colors.transparent, 
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            height: 85,
                            width: 85,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 85,
                              width: 85,
                              color: Colors.grey,
                              child: const Icon(Icons.person),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          actor['name'] ?? 'Desconocido',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        // Vista expandida
        else
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cast.length,
                itemBuilder: (context, index) {
                  final actor = widget.cast[index];
                  final profilePath = actor['profile_path'];
                  final imageUrl = profilePath != null
                      ? 'https://image.tmdb.org/t/p/w200$profilePath'
                      : 'https://via.placeholder.com/150x150.png?text=No+Image';

                  return Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => _showActorDetails(context, actor),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            height: 55,
                            width: 55,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        actor['name'] ?? 'Desconocido',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        actor['character'] ?? '',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Botón para volver a contraer la lista
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isCastExpanded = false;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white70,
                ),
                label: const Text(
                  'Ver menos',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
      ],
    );
  }
}