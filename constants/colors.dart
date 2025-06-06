import 'package:flutter/material.dart';

// Cores do aplicativo
class AppColors {
  // Cores para o treino de cores
  static const Color red = Color(0xFFBF0F0C);      // Vermelho
  static const Color green = Color(0xFF009951);    // Verde
  static const Color yellow = Color(0xFFFFD700);   // Amarelo
  static const Color blue = Color(0xFF0066CC);     // Azul
  static const Color purple = Color(0xFF8A2BE2);   // Roxo
  static const Color orange = Color(0xFFFF8C00);   // Laranja
  static const Color pink = Color(0xFFFF69B4);     // Rosa
  static const Color brown = Color(0xFF8B4513);    // Marrom

  // Cores para os cards de treino
  static final Color redCard = Colors.red.shade400;
  static final Color greenCard = Colors.green.shade400;
  static final Color amberCard = Colors.amber.shade400;
  static final Color purpleCard = Colors.purple.shade400;
  static final Color blueCard = Colors.blue.shade400;
  static final Color tealCard = Colors.teal.shade400;

  // Cores para os gradientes
  static final List<Color> menuGradient = [Colors.blue.shade300, Colors.purple.shade300];
  static final List<Color> colorTrainingGradient = [Colors.blue.shade100, Colors.blue.shade200];
  static final List<Color> congratulationsGradient = [Colors.blue.shade200, Colors.blue.shade500];
  static final List<Color> dashboardGradient = [Colors.indigo.shade300, Colors.indigo.shade700];
}