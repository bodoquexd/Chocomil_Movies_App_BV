import 'package:flutter/material.dart';

class FeaturedMovieWidget extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FeaturedMovieWidget({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 250,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],

        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),

        child: Align(
          alignment: Alignment.bottomCenter,

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                Text(
                  title,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () {},

                    icon: const Icon(Icons.add),

                    label: const Text(
                      'Agregar a mi lista',
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}