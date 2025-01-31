import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static final ThemeData _lightTheme = ThemeData(
    cardColor:  Color.fromARGB(255, 35, 13, 63),
    brightness: Brightness.light,
    primaryColor:  const Color.fromARGB(255, 69, 67, 67),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme:  AppBarTheme(
      titleTextStyle: GoogleFonts.firaSans(
        color: Colors.white,
        fontSize: 20,
      ),
      backgroundColor: const Color.fromARGB(255, 69, 67, 67),
      foregroundColor: Colors.white,
    ),
    textTheme:  TextTheme(
      headlineLarge:  GoogleFonts.firaSans(
              color: Colors.black,
              fontSize: 30,
            ),
      bodyMedium:  GoogleFonts.firaSans(
              color: Colors.black,
              fontSize: 16,
            ),
      bodySmall:  GoogleFonts.firaSans(
              color: Colors.black,
              fontSize: 16,
            ),
    )
  );

  static final ThemeData _darkTheme = ThemeData(
    cardColor: const Color.fromARGB(255, 69, 67, 67),
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.firaSans(
        color: Colors.white,
        fontSize: 20,
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme:  TextTheme(
      bodyMedium:  GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 16.sp,
            ),
      bodySmall:  GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 14.sp,
            ),
    )
  );
}