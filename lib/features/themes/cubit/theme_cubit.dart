import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../dark_theme.dart';
import '../light_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDarkMode = false; // Changed to true for dark mode default

  ThemeCubit() : super(lightMode); // Changed to darkMode

  bool get isDarkMode {
    // Check if current state matches dark theme
    return state == darkMode;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    if (_isDarkMode) {
      emit(darkMode);
    } else {
      emit(lightMode);
    }
  }

  void setLightTheme() {
    _isDarkMode = false;
    emit(lightMode);
  }

  void setDarkTheme() {
    _isDarkMode = true;
    emit(darkMode);
  }
}
