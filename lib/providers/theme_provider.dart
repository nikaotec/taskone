import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference(); // Carrega a preferência ao inicializar
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode =
        prefs.getBool('isDarkMode') ??
        false; // Recupera a preferência ou usa false como padrão
    notifyListeners(); // Notifica os listeners após carregar a preferência
  }

  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value); // Salva a preferência
    _isDarkMode = value;
    notifyListeners(); // Notifica os listeners sobre a mudança de tema
  }
}
