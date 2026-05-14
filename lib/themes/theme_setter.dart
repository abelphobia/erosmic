import 'package:flutter/material.dart'; // provides a general material design widgets available to be used in other files
import 'package:erosmic/themes/dark_mode.dart';
import 'package:erosmic/themes/light_mode.dart';

// Themeprovider is allowed to be changed with ChangeNotifier setting the mode as a lightmode
class ThemeProvider extends ChangeNotifier {
  // for light mode | _themedata is set to private with the _ applied.
  ThemeData _themeData = lightMode;

  // get theme
  ThemeData get themeData => _themeData;

  // for dark mode
  bool get isDarkMode => _themeData == darkMode;

  // setting the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }

    //update ui
    notifyListeners();
  }
}
