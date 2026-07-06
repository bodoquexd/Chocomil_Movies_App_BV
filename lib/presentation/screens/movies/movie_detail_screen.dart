import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isLoading = true;
  List<dynamic> cast = [];
  List<dynamic> reviews = [];
  String? trailerKey;
  
  YoutubePlayerController? _trailerController;

  @override
  void initState() {
    super.initState();
    _fetchMovieExtraDetails();
  }

  @override
  void dispose() {
    _trailerController?.dispose();
    super.dispose();
  }

  Future<void> _fetchMovieExtraDetails() async {
    final apiKey = dotenv.env['THE_MOVIEDB_KEY'] ?? '';
    final movieId = widget.movie.id; 
    
    if (apiKey.isEmpty) {
      debugPrint('⚠️ Error: No se encontró la variable THE_MOVIEDB_KEY en tu archivo .env');
      setState(() => isLoading = false);
      return;
    }

    try {
      final castRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey&language=es-MX'));
      if (castRes.statusCode == 200) {
        final castData = json.decode(castRes.body);
        cast = (castData['cast'] as List).take(10).toList();
      }

      final reviewsRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey'));
      if (reviewsRes.statusCode == 200) {
        final reviewsData = json.decode(reviewsRes.body);
        reviews = (reviewsData['results'] as List).take(5).toList();
      }

      final videoRes = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey&language=es-MX'));
      if (videoRes.statusCode == 200) {
        final videoData = json.decode(videoRes.body);
        final videos = videoData['results'] as List;
        for (var v in videos) {
          if (v['site'] == 'YouTube' && (v['type'] == 'Trailer' || v['type'] == 'Teaser')) {
            trailerKey = v['key'];
            break;
          }
        }
        
        if (trailerKey == null) {
          final videoResEn = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey'));
          if (videoResEn.statusCode == 200) {
            final videoDataEn = json.decode(videoResEn.body);
            for (var v in videoDataEn['results']) {
              if (v['site'] == 'YouTube' && v['type'] == 'Trailer') {
                trailerKey = v['key'];
                break;
              }
            }
          }
        }

        if (trailerKey != null) {
          _trailerController = YoutubePlayerController(
            initialVideoId: trailerKey!,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              disableDragSeek: false,
              loop: false,
              isLive: false,
              forceHD: false,
              enableCaption: true,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error cargando detalles: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221A16), 
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF221A16),
            expandedHeight: 480,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.movie.posterPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.white54),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.transparent, Color(0xFF221A16)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          widget.movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    
                    const Text('Sinopsis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                    const SizedBox(height: 10),
                    Text(
                      widget.movie.overview.isNotEmpty ? widget.movie.overview : 'No hay sinopsis disponible.',
                      style: const TextStyle(fontSize: 15, color: Color.fromARGB(238, 228, 220, 220), height: 1.4),
                    ),
                    const SizedBox(height: 25),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator(color: Colors.orange))
                    else ...[
                      
                      if (cast.isNotEmpty) ...[
                        const Text('Reparto Principal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cast.length,
                            itemBuilder: (context, index) {
                              final actor = cast[index];
                              final profilePath = actor['profile_path'];
                              final imageUrl = profilePath != null 
                                  ? 'https://image.tmdb.org/t/p/w200$profilePath'
                                  : 'https://via.placeholder.com/150x150.png?text=No+Image';

                              return Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: 85,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(imageUrl, height: 85, width: 85, fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(height: 85, width: 85, color: Colors.grey, child: const Icon(Icons.person)),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      actor['name'] ?? 'Desconocido',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      if (_trailerController != null) ...[
                        const Text('Tráiler Oficial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: YoutubePlayer(
                            controller: _trailerController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.orange,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.orange,
                              handleColor: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],

                      // COMENTARIOS
                      if (reviews.isNotEmpty) ...[
                        const Text('Comentarios de la Comunidad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            final author = review['author'] ?? 'Anónimo';
                            final content = review['content'] ?? '';
                            final rating = review['author_details']?['rating'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E241F),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.orange.shade800,
                                            radius: 12,
                                            child: Text(
                                              author[0].toUpperCase(),
                                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(author, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      ),
                                      if (rating != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 14),
                                            const SizedBox(width: 3),
                                            Text(rating.toString(), style: const TextStyle(color: Colors.white70, fontSize: 12))
                                          ],
                                        )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    content,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white10, fontSize: 13, height: 1.3),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        const Text('Aún no hay comentarios para esta película.', style: TextStyle(color: Colors.white54)),
                      ],
                      
                      const SizedBox(height: 20),
                    ], 
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}