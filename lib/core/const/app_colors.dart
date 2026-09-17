import 'package:flutter/material.dart';

abstract final class AppColors {
  static const MaterialColor white = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFEFEFE),
      100: Color(0xFFFDFDFD),
      200: Color(0xFFFCFCFC),
      300: Color(0xFFFBFBFB),
      400: Color(0xFFFAFAFA),
      500: Color(0xFFD0D0D0),
      600: Color(0xFFA6A6A6),
      700: Color(0xFF7D7D7D),
      800: Color(0xFF535353),
      900: Color(0xFF323232),
    },
  );

  static const Color whiteBase = Color(0xFFF9F9F9);

  static const MaterialColor purpleBase = MaterialColor(
    0xFFD21E6A,
    <int, Color>{
      50: Color(0xFFF6D2E1),
      100: Color(0xFFF0B4CD),
      200: Color(0xFFE98FB5),
      300: Color(0xFFE1699C),
      400: Color(0xFFDA4483),
      500: Color(0xFFD21E6A),
      600: Color(0xFFAF1958),
      700: Color(0xFF8C1447),
      800: Color(0xFF690F35),
      900: Color(0xFF460A23),
    },
  );

  static const Color purple100 = Color(0xFF2A0615);

  static const MaterialColor black = MaterialColor(
    0xFF000000,
    <int, Color>{
      50: Color(0xFFCECfd0),
      100: Color(0xFFAEAFB1),
      200: Color(0xFF86888A),
      300: Color(0xFF5D6063),
      400: Color(0xFF34383C),
      500: Color(0xFF0C1015),
      600: Color(0xFF0A0D12),
      700: Color(0xFF080B0E),
      800: Color(0xFF06080B),
      900: Color(0xFF040507),
    },
  );

  static const Color blackBase = Color(0xFF020304);

  static const Color grey = Color(0xFF535353);
  static const Color error = Color(0xFFCC1010);
  static const Color success = Color(0xFF0CB359);
  static const Color lightPink = Color(0xFFF9ECF0);
  static const Color lemon = Color(0xFFC8D444);
  static const Color blue = Color(0xFF1019A4);

  static const Color magenta10 = Color(0xFFF7F2FA);
  static const Color magenta90 = Color(0xFF65558F);
  static const Color magenta100 = Color(0xFF1D192B);

  static const Color grey10 = Color(0xFF79747E);
  static const Color grey20 = Color(0xFF878787);
  static const Color grey30 = Color(0xFF535353);
  static const Color grey90 = Color(0xFF1D1B20);
  static const Color grey40 = Color(0xFF49454F);

  static const Color pink10 = Color(0xFFE8DEF8);

  static const Color amber10 = Color(0xFFFEF3E7);
  static const Color amber90 = Color(0xFF914D16);
  static const Color amber100 = Color(0xFF452A10);
}