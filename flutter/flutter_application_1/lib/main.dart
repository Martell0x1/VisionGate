import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_gate/Screens/loading_screen.dart';
import 'package:vision_gate/themes/theme_model.dart'; // Import your ThemeModel

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeModel(), // Provide ThemeModel
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            title: 'Complete Gate',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(), // Add dark theme
            themeMode: themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
            home: LoadingScreen(),
          );
        },
      ),
    );
  }
}