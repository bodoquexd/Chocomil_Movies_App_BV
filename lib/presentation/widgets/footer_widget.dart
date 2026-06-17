import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 20,
      ),

      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(
          top: BorderSide(
            color: Colors.white24,
            width: 1,
          ),
        ),
      ),

      child: Column(
        children: [

          const Icon(
            Icons.movie_creation_outlined,
            color: Colors.red,
            size: 40,
          ),

          const SizedBox(height: 10),

          const Text(
            'Chocomil Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tu plataforma favorita para descubrir películas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [

              Icon(
                Icons.facebook,
                color: Colors.white70,
              ),

              SizedBox(width: 20),

              Icon(
                Icons.camera_alt_outlined,
                color: Colors.white70,
              ),

              SizedBox(width: 20),

              Icon(
                Icons.alternate_email,
                color: Colors.white70,
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(
            color: Colors.white24,
          ),

          const SizedBox(height: 10),

          const Text(
            '© 2026 Chocomil Movies. Todos los derechos reservados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}