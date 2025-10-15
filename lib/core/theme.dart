import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final seed = const Color(0xFFff357a);

  static ThemeData get light {
    final base = ThemeData(colorSchemeSeed: seed, brightness: Brightness.light, useMaterial3: true);
    return base.copyWith(textTheme: GoogleFonts.poppinsTextTheme(base.textTheme));
  }

  static ThemeData get dark {
    final base = ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark, useMaterial3: true);
    return base.copyWith(textTheme: GoogleFonts.poppinsTextTheme(base.textTheme));
  }
}