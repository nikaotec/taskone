import 'package:flutter/material.dart';

class AppColorScheme {
  // Paleta de cores para o modo claro (Neumorfismo)
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4A90E2), // Azul suave
    onPrimary: Colors.white, // Texto em elementos primários
    secondary: Color(0xFFFFA726), // Laranja como cor secundária
    onSecondary: Colors.black, // Texto em elementos secundários
    error: Color(0xFFE57373), // Vermelho suave para erros
    onError: Colors.white, // Texto em elementos de erro
    background: Color(0xFFF0F0F0), // Fundo da tela (cinza claro)
    onBackground: Color(0xFF333333), // Texto principal (cinza escuro)
    surface: Color(0xFFF5F5F5), // Fundo de cards e superfícies
    onSurface: Color(0xFF333333), // Texto em superfícies
    surfaceContainerHighest: Color(0xFFE0E0E0), // Bordas/divisores
    onSurfaceVariant: Color(0xFF666666), // Texto secundário (cinza médio)
  );

  // Paleta de cores para o modo escuro (Neumorfismo)
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF4A90E2), // Azul suave
    onPrimary: Colors.white, // Texto em elementos primários
    secondary: Color(0xFFFFA726), // Laranja como cor secundária
    onSecondary: Colors.black, // Texto em elementos secundários
    error: Color(0xFFEF5350), // Vermelho claro para erros
    onError: Colors.black, // Texto em elementos de erro
    background: Color(0xFF1E1E1E), // Fundo da tela (preto escuro)
    onBackground: Color(0xFFE0E0E0), // Texto principal (cinza claro)
    surface: Color(0xFF2C2C2C), // Fundo de cards e superfícies
    onSurface: Color(0xFFE0E0E0), // Texto em superfícies
    surfaceContainerHighest: Color(0xFF424242), // Bordas/divisores
    onSurfaceVariant: Color(0xFFB0B0B0), // Texto secundário (cinza médio claro)
  );
}
