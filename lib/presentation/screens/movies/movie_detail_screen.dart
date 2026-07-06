import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockCast = [
      {'name': 'Actor Principal 1', 'character': 'Héroe', 'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'},
      {'name': 'Actriz Principal 2', 'character': 'Heroína', 'url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'},
      {'name': 'Actor Secundario 3', 'character': 'Villano', 'url': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150'},
      {'name': 'Actriz Secundaria 4', 'character': 'Aliada', 'url': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150'},
      {'name': 'Actor 5', 'character': 'Mentor', 'url': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'},
    ];

    final List<Map<String, dynamic>> mockComments = [
      {'user': 'CinefiloAnonimo', 'rating': 4.5, 'text': '¡Una obra maestra absoluta! Los efectos visuales y la banda sonora te atrapan desde el primer segundo.'},
      {'user': 'MovieLover99', 'rating': 3.0, 'text': 'Está entretenida para pasar el rato en el fin de semana, aunque el final me pareció un poco predecible.'},
      {'user': 'CriticoChocomil', 'rating': 5.0, 'text': 'De las mejores películas que he visto este año. Altamente recomendada para ver en la pantalla más grande posible.'},
    ];

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
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.posterPath,
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
                      movie.title,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    
                    const Text(
                      'Sinopsis',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.overview.isNotEmpty ? movie.overview : 'No hay sinopsis disponible.',
                      style: const TextStyle(fontSize: 15, color: Colors.white10, height: 1.4),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    const Text(
                      'Reparto Principal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mockCast.length,
                        itemBuilder: (context, index) {
                          final actor = mockCast[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 15),
                            width: 85,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    actor['url']!,
                                    height: 85,
                                    width: 85,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  actor['name']!,
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
                    
                    const Text(
                      'Tráiler Oficial',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reproduciendo tráiler... (Simulado)')),
                        );
                      },
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(movie.posterPath),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.55), BlendMode.darken),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.orange,
                            size: 65,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    const Text(
                      'Comentarios de la Comunidad',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mockComments.length,
                      itemBuilder: (context, index) {
                        final comment = mockComments[index];
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
                                          comment['user']![0].toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        comment['user']!,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        comment['rating'].toString(),
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                comment['text']!,
                                style: const TextStyle(color: Colors.white10, fontSize: 13, height: 1.3),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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