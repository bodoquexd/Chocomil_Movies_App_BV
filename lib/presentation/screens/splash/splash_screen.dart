import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() {
      _logoOpacity = 0.0;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonPrimary,
      body: Center(
        child: AnimatedOpacity(
          opacity: _logoOpacity,
          duration: const Duration(milliseconds: 500), 
          curve: Curves.easeInOut,
          child: Image.asset(
            'assets/images/splash.png',
            width: 250,
          ),
        ),
      ),
    );
  }
}