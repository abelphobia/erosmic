import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Colors.blueGrey,
    secondary: Colors.tealAccent,
    inversePrimary: Colors.grey.shade600,
    surface: const Color(0xFF121212),
    onSurface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white70),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white70),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Colors.white,
    iconColor: Colors.white,
    tileColor: Color(0xFF121212),
  ),
  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Colors.white),
    trackColor: WidgetStatePropertyAll(Colors.tealAccent),
  ),
  cardColor: Color(0xFF1E1E1E),
  dividerColor: Colors.white24,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);