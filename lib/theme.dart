import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = "theme";

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  // Toggle between light and dark themes
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme();
    notifyListeners();
  }

  // Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getBool(_themeKey);
    if (theme != null) {
      _isDarkMode = theme;
      notifyListeners(); // Notify listeners after loading the theme
    }
  }

  // Save the current theme to SharedPreferences
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  // Light theme configuration
  static final ThemeData _lightTheme = ThemeData(
    cardColor: const Color.fromARGB(255, 35, 13, 63),
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 69, 67, 67),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.firaSans(
        color: Colors.white,
        fontSize: 20,
      ),
      backgroundColor: const Color.fromARGB(255, 69, 67, 67),
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.firaSans(
        color: Colors.black,
        fontSize: 30,
      ),
      bodyMedium: GoogleFonts.firaSans(
        color: Colors.black,
        fontSize: 16,
      ),
      bodySmall: GoogleFonts.firaSans(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
  );

  // Dark theme configuration
  static final ThemeData _darkTheme = ThemeData(
    cardColor: const Color.fromARGB(255, 69, 67, 67),
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.firaSans(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.firaSans(
        color: Colors.white,
        fontSize: 16.sp,
      ),
      bodySmall: GoogleFonts.firaSans(
        color: Colors.white,
        fontSize: 14.sp,
      ),
    ),
  );
}