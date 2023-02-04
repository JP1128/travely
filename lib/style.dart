import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var primaryColor = 0xFF26A9DD;
var strokeColor = 0xFFD2D2D2;

Decoration boxDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Color(strokeColor)),
  borderRadius: BorderRadius.circular(10),
);

ThemeData theme = ThemeData(
  useMaterial3: true,
  primaryColor: Color(primaryColor),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    titleMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 13,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 20,
    ),
    border: OutlineInputBorder(),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
        shape: MaterialStatePropertyAll(
      CircleBorder(side: BorderSide(color: Color(strokeColor))),
    )),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        GoogleFonts.roboto(
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
      backgroundColor: MaterialStatePropertyAll(Color(primaryColor)),
      fixedSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  ),
);
