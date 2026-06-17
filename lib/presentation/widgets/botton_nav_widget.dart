import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavWidget extends StatelessWidget {

  final int currentIndex;

  const BottomNavWidget({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      backgroundColor: const Color(0xFF1E1E1E),

      type: BottomNavigationBarType.fixed,

      currentIndex: currentIndex,

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.bookmark),
          label: 'Mi Lista',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],

      onTap: (index) {

        switch (index) {

          case 0:
            context.go('/');
            break;

          case 3:
            context.go('/login');
            break;
        }
      },
    );
  }
}