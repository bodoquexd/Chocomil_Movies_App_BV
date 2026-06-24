import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

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
      child: InkWell(
        onTap: () => onTap(index),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isActive ? 1.15 : 1.0,
            child: Icon(
              icon,
              size: 28,
              color: isActive
                  ? Colors.white
                  : AppColors.grayLight,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.black,
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