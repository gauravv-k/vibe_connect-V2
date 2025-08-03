import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
// very dark app bar + drawer color
    surface: Color.fromARGB(255, 9, 9, 9),
// slightly Light
    primary: Color.fromARGB(255, 105, 105, 105),
// dark
    secondary: Color.fromARGB(255, 20, 20, 20),
// slightly dark
    tertiary: Color.fromARGB(255, 44, 44, 44),
// very light
    inversePrimary: Color.fromARGB(255, 195, 195, 195),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 9, 9, 9),
);
