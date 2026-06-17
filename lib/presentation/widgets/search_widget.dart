import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar película...',

        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}