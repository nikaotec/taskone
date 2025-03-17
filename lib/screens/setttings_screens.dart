import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../themes/color_scheme.dart'; // Importe o esquema de cores

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(); // Volta para a tela anterior
            } else {
              context.go('/home'); // Redireciona para a tela inicial
            }
          },
        ),
        backgroundColor:
            Theme.of(
              context,
            ).colorScheme.surface, // Usa a cor de superfície do tema
        foregroundColor:
            Theme.of(
              context,
            ).colorScheme.onSurface, // Usa a cor do texto do tema
        elevation: 0, // Remove a sombra
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modo Escuro',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(
                      context,
                    ).colorScheme.onBackground, // Usa a cor do texto do tema
              ),
            ),
            Card(
              elevation: 2, // Sombra suave
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  'Ativar Modo Escuro',
                  style: TextStyle(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.onSurface, // Usa a cor do texto do tema
                  ),
                ),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value); // Altera o tema
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
