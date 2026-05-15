import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade200,
  colorScheme: ColorScheme.light(
    primary: Colors.blue.shade200,
    secondary: Colors.tealAccent.shade200,
    inversePrimary: Colors.grey.shade300,
    surface: Colors.grey.shade200,
    onSurface: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade200,
    foregroundColor: Colors.black,
    elevation: 0,
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black54),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black54),
  ),
  listTileTheme: ListTileThemeData(
    textColor: Colors.black,
    iconColor: Colors.black,
    tileColor: Colors.grey.shade200,
  ),
  cardColor: Colors.white,
  dividerColor: Colors.black12,
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
);