import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskone/firebase_options.dart';
import 'package:taskone/providers/theme_provider.dart';
import 'package:taskone/themes/themes.dart';
import 'package:taskone/utils/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'providers/filter_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false; 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
      ],
      child: CalendarControllerProvider( 
        controller: EventController(),
        child: MyApp(isDarkMode: isDarkMode)),
    ),
  );
}

class MyApp extends StatelessWidget {
   final bool isDarkMode;
   MyApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: lightNeumorphicTheme(), // Tema neumórfico claro
      darkTheme: darkNeumorphicTheme(), // Tema neumórfico escuro
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, 
    );
  }
}
