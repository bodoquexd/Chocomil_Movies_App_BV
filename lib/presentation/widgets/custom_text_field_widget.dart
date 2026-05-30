import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    super.key, 
    required this.hintText, 
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFC78458),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}