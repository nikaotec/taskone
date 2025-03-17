import 'package:flutter/material.dart';
import 'color_scheme.dart'; // Importe o esquema de cores

ThemeData lightNeumorphicTheme() {
  return ThemeData(
    useMaterial3: true, // Habilita o Material 3
    colorScheme: AppColorScheme.lightColorScheme,
    scaffoldBackgroundColor: AppColorScheme.lightColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorScheme.lightColorScheme.surface,
      foregroundColor: AppColorScheme.lightColorScheme.onSurface,
      elevation: 0, // Remove a sombra do AppBar
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColorScheme.lightColorScheme.onSurface,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColorScheme.lightColorScheme.surface,
      elevation: 0, // Remove a sombra padrão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bordas arredondadas
      ),
      margin: EdgeInsets.all(8),
      shadowColor: Colors.black.withOpacity(0.2), // Sombra suave
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: AppColorScheme.lightColorScheme.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColorScheme.lightColorScheme.onBackground,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorScheme.lightColorScheme.primary,
        foregroundColor: AppColorScheme.lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0, // Remove a sombra padrão
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shadowColor: Colors.black.withOpacity(0.2), // Sombra suave
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorScheme.lightColorScheme.secondary,
      foregroundColor: AppColorScheme.lightColorScheme.onSecondary,
      elevation: 6, // Sombra mais pronunciada
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorScheme.lightColorScheme.surface,
      selectedItemColor: AppColorScheme.lightColorScheme.primary,
      unselectedItemColor: AppColorScheme.lightColorScheme.onSurfaceVariant,
      elevation: 4, // Sombra leve
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColorScheme.lightColorScheme.surface,
      elevation: 4, // Sombra leve
    ),
  );
}

ThemeData darkNeumorphicTheme() {
  return ThemeData(
    useMaterial3: true, // Habilita o Material 3
    colorScheme: AppColorScheme.darkColorScheme,
    scaffoldBackgroundColor: AppColorScheme.darkColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorScheme.darkColorScheme.surface,
      foregroundColor: AppColorScheme.darkColorScheme.onSurface,
      elevation: 0, // Remove a sombra do AppBar
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColorScheme.darkColorScheme.onSurface),
    ),
    cardTheme: CardTheme(
      color: AppColorScheme.darkColorScheme.surface,
      elevation: 0, // Remove a sombra padrão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bordas arredondadas
      ),
      margin: EdgeInsets.all(8),
      shadowColor: Colors.white.withOpacity(0.2), // Sombra suave
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: AppColorScheme.darkColorScheme.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColorScheme.darkColorScheme.onBackground,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColorScheme.darkColorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorScheme.darkColorScheme.primary,
        foregroundColor: AppColorScheme.darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0, // Remove a sombra padrão
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shadowColor: Colors.white.withOpacity(0.2), // Sombra suave
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorScheme.darkColorScheme.secondary,
      foregroundColor: AppColorScheme.darkColorScheme.onSecondary,
      elevation: 6, // Sombra mais pronunciada
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorScheme.darkColorScheme.surface,
      selectedItemColor: AppColorScheme.darkColorScheme.primary,
      unselectedItemColor: AppColorScheme.darkColorScheme.onSurfaceVariant,
      elevation: 4, // Sombra leve
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColorScheme.darkColorScheme.surface,
      elevation: 4, // Sombra leve
    ),
  );
}
