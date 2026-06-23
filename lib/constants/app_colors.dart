import 'package:flutter/material.dart';

class AppColors {
  // Paleta Verde Escura (Primary)
  static const Color primary = Color(
    0xFF1B4D3E,
  ); // Verde Floresta Escuro (Brunswick Green)
  static const Color primaryLight = Color(0xFF2C6B56); // Verde Médio
  static const Color primaryDark = Color(
    0xFF0D2D24,
  ); // Verde Floresta Bem Escuro

  // Cores Complementares e Secundárias
  static const Color secondary = Color(0xFF4A7C59); // Verde Folha Suave
  static const Color accent = Color(0xFF90BE6D); // Verde Claro / Oliva Suave
  static const Color accentComplement = Color(
    0xFFE27D60,
  ); // Coral / Rosa Queimado (Complementar ao Verde)

  // Cores Neutras
  static const Color background = Color(
    0xFFF2F5F3,
  ); // Cinza Claro com tom esverdeado
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1E2722); // Cinza Grafite Escuro
  static const Color textSecondary = Color(0xFF5A6660); // Cinza Médio

  // Cores de Status
  static const Color error = Color(0xFFC0392B); // Vermelho Escuro
  static const Color success = Color(0xFF2E7D32); // Verde Sucesso
}
