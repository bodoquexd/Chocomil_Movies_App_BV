import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';

class CastSectionWidget extends StatefulWidget {
  final List<dynamic> cast;

  const CastSectionWidget({super.key, required this.cast});

  @override
  State<CastSectionWidget> createState() => _CastSectionWidgetState();
}

class _CastSectionWidgetState extends State<CastSectionWidget> {
  bool _isCastExpanded = false;

  void _showActorDetails(BuildContext context, dynamic actor) {
    final actorId = actor['id'];
    final profilePath = actor['profile_path'];
    final imageUrl = profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://via.placeholder.com/300x450.png?text=No+Image';

    // Capturamos el provider de manera segura antes de abrir el diálogo
    final movieDetailProvider = context.read<MovieDetailProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF151515),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            height: 500,
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
                      child: const Icon(Icons.person,
                          size: 60, color: Colors.white),
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

                      // Cargar datos extra del actor a través del Provider
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Detalles básicos del actor
                              FutureBuilder<Map<String, dynamic>>(
                                future: movieDetailProvider.getActorDetails(actorId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.orange));
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text(
                                        'No hay más detalles disponibles.',
                                        style: TextStyle(color: Colors.white54));
                                  }

                                  final data = snapshot.data!;
                                  final bio = data['biography']
                                              ?.toString()
                                              .isNotEmpty ==
                                          true
                                      ? data['biography']
                                      : 'Biografía no disponible en español.';
                                  final birthday =
                                      data['birthday'] ?? 'Desconocido';
                                  final placeOfBirth =
                                      data['place_of_birth'] ?? 'Desconocido';

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow('Nacimiento:', birthday),
                                      const SizedBox(height: 4),
                                      _buildDetailRow('Lugar:', placeOfBirth),
                                      const SizedBox(height: 12),
                                      const Text('Biografía:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                      const SizedBox(height: 4),
                                      Text(
                                        bio,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            height: 1.3),
                                      ),
                                      const Divider(
                                          color: Colors.white24, height: 20),
                                    ],
                                  );
                                },
                              ),

                              const Text('Películas Destacadas:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              const SizedBox(height: 8),

                              // Películas del actor a través del Provider
                              FutureBuilder<Map<String, dynamic>>(
                                future: movieDetailProvider.getActorMovies(actorId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                        height: 100,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.orange)));
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty ||
                                      snapshot.data!['cast'] == null ||
                                      (snapshot.data!['cast'] as List).isEmpty) {
                                    return const Text(
                                        'Filmografía no disponible.',
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12));
                                  }

                                  final movies =
                                      snapshot.data!['cast'] as List<dynamic>;
                                  final displayedMovies =
                                      movies.take(10).toList();

                                  return SizedBox(
                                    height: 145,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: displayedMovies.length,
                                      itemBuilder: (context, index) {
                                        final movie = displayedMovies[index];
                                        final moviePosterPath =
                                            movie['poster_path'];
                                        final movieImageUrl = moviePosterPath != null
                                            ? 'https://image.tmdb.org/t/p/w185$moviePosterPath'
                                            : 'https://via.placeholder.com/92x138.png?text=No+Movie';
                                        final movieTitle =
                                            movie['title'] ?? 'Sin título';

                                        return Container(
                                          width: 75,
                                          margin: const EdgeInsets.only(
                                              right: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  movieImageUrl,
                                                  height: 95,
                                                  width: 65,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, _, _) =>
                                                      Container(
                                                    height: 95,
                                                    width: 65,
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                        Icons.movie,
                                                        size: 28,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Expanded(
                                                child: Text(
                                                  movieTitle,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Botón cerrar
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar',
                              style: TextStyle(color: Colors.orange)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: '$title ',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          TextSpan(
              text: value,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
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

                final actor = widget.cast[index];
                final profilePath = actor['profile_path'];
                final imageUrl = profilePath != null
                    ? 'https://image.tmdb.org/t/p/w200$profilePath'
                    : 'https://via.placeholder.com/150x150.png?text=No+Image';

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