import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
          side: MaterialStateProperty.all(
            const BorderSide(color: Colors.deepPurple),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.deepPurple,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
