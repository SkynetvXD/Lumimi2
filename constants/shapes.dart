import 'package:flutter/material.dart';

// Classe para definir as formas no aplicativo
class AppShapes {
  // Tipos de formas
  static const int circle = 0;
  static const int square = 1;
  static const int triangle = 2;
  static const int rectangle = 3;
  static const int pentagon = 4;
  static const int hexagon = 5;
  static const int star = 6;
  static const int heart = 7;
  
  // Nomes das formas
  static String getName(int shapeType) {
    switch (shapeType) {
      case circle:
        return "Círculo";
      case square:
        return "Quadrado";
      case triangle:
        return "Triângulo";
      case rectangle:
        return "Retângulo";
      case pentagon:
        return "Pentágono";
      case hexagon:
        return "Hexágono";
      case star:
        return "Estrela";
      case heart:
        return "Coração";
      default:
        return "Forma";
    }
  }
  
  // Cores das formas (usando cores do AppColors)
  static Color getColor(int shapeType) {
    switch (shapeType) {
      case circle:
        return Colors.red;
      case square:
        return Colors.blue;
      case triangle:
        return Colors.green;
      case rectangle:
        return Colors.purple;
      case pentagon:
        return Colors.orange;
      case hexagon:
        return Colors.teal;
      case star:
        return Colors.amber;
      case heart:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}