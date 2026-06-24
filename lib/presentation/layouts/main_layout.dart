import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/botton_nav_widget.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child; 

  const MainLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/watchlist')) return 1;
    if (location.startsWith('/favorites')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: child, 
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }
}