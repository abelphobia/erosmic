import 'package:flutter/material.dart';
import 'package:erosmic/themes/dark_mode.dart';
import 'package:erosmic/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // for light mode
  ThemeData _themeData = lightMode;

  // for dark mode
  bool get isDarkMode => _themeData == darkMode;

  // get theme
  ThemeData get themeData => _themeData;

  // setting the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    //update ui
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
  }
}
