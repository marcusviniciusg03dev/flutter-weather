import 'package:flutter/material.dart';

final mainTheme = ThemeData(
  fontFamily: 'Inter',
  appBarTheme:
      const AppBarTheme(backgroundColor: Color.fromARGB(255, 8, 18, 35)),
  scaffoldBackgroundColor: Color.fromARGB(255, 20, 145, 255),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color.fromARGB(255, 255, 250, 248)),
      bodyLarge: TextStyle(color: Color.fromARGB(255, 255, 250, 248)),
      bodySmall: TextStyle(color: Color.fromARGB(255, 255, 250, 248)),
      headlineLarge: TextStyle(color: Color.fromARGB(255, 255, 250, 248)),
      headlineMedium: TextStyle(
          color: Color.fromARGB(255, 255, 250, 248),
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Color.fromARGB(255, 255, 250, 248))),
);
