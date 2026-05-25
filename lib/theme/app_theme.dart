import 'package:flutter/material.dart';

class AppTheme 
{
  //Themedata: es una clase que contiene la información de los colores
  //getTheme: es un método que devuelve una instancia de ThemeData con los colores personalizados
  ThemeData getTheme() => ThemeData 
  (
    useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2862F5)
  );
}