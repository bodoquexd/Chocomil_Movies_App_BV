import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.textPrimary,
      backgroundColor: AppColors.primaryDark,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
