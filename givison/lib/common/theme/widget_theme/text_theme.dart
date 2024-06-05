import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme=TextTheme(
      displayMedium: GoogleFonts.montserrat(
        color: Colors.black,
        fontSize: 20,
      ),
      titleSmall: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold
        ),
      titleLarge: GoogleFonts.montserrat(
        color: Colors.black,
        fontSize: 70,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 10,
        ),
      displayLarge: GoogleFonts.montserrat(
        color: Colors.black,
        fontSize: 40,
      ),
    );
  static TextTheme darkTextTheme=TextTheme(
    displayMedium: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 15,
      ),
      titleSmall: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold
        ),
    );
}