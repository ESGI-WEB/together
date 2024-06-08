import 'package:flutter/material.dart';

class AppTheme {
  static ColorScheme get scheme {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff9f112e),
      surfaceTint: Color(0xffb4243b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd33c4f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff97454a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffa4a7),
      onSecondaryContainer: Color(0xff5a161e),
      tertiary: Color(0xff725b23),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff9d994),
      onTertiaryContainer: Color(0xff56420a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xffffffff),
      onBackground: Color(0xff261818),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff271818),
      surfaceVariant: Color(0xfffedada),
      onSurfaceVariant: Color(0xff594041),
      outline: Color(0xff8d7070),
      outlineVariant: Color(0xffe1bebe),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3d2c2d),
      inversePrimary: Color(0xffffb3b5),
    );
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      canvasColor: scheme.background,
      cardColor: scheme.background,
      disabledColor: const Color(0xfff5f5f5),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: scheme.primary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: scheme.primary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: scheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: scheme.primary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: scheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: scheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: scheme.primary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: scheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: scheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: scheme.onBackground,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(
          color: scheme.onBackground,
          fontSize: 12,
        ),
        bodySmall: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: scheme.onPrimary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          color: scheme.onPrimary,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: scheme.onPrimary,
          fontSize: 10,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: scheme.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          disabledForegroundColor: scheme.onPrimaryContainer,
          backgroundColor: scheme.primary,
          disabledBackgroundColor: scheme.primaryContainer,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          disabledForegroundColor: scheme.primaryContainer,
          side: BorderSide(
            color: scheme.primary,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        foregroundColor: scheme.primary,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shadowColor: scheme.background,
        surfaceTintColor: scheme.background,
      ),
    );
  }
}
