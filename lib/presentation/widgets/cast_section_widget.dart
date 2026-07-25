import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chocomil_movies_app_bv/providers/movie_detail_provider.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/movies/actor_detail_screen.dart'; 

class CastSectionWidget extends StatefulWidget {
  final List<dynamic> cast;

  const CastSectionWidget({super.key, required this.cast});

  @override
  State<CastSectionWidget> createState() => _CastSectionWidgetState();
}

class _CastSectionWidgetState extends State<CastSectionWidget> {
  bool _isCastExpanded = false;

  void _showActorDetails(BuildContext context, dynamic actor) {
    final movieDetailProvider = context.read<MovieDetailProvider>();

    // Reemplazamos MaterialPageRoute por PageRouteBuilder para evitar el flash blanco
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ActorDetailScreen(
          actor: actor,
          movieDetailProvider: movieDetailProvider,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Usamos una transición suave de opacidad (Fade)
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300), // Duración opcional
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