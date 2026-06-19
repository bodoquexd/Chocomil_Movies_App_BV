import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavWidget extends StatefulWidget {
  final int currentIndex;

  const BottomNavWidget({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.currentIndex;
  }

  void onTap(int index) {
    setState(() => selected = index);

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/watchlist');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  Widget buildItem({
    required IconData icon,
    required int index,
  }) {
    final isActive = selected == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isActive ? 1.2 : 1.0,
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.white54,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(
          top: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: [
          buildItem(icon: Icons.home, index: 0),
          buildItem(icon: Icons.bookmark, index: 1),
          buildItem(icon: Icons.favorite, index: 2),
          buildItem(icon: Icons.person, index: 3),
        ],
      ),
    );
  }
}