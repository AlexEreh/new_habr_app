import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme buildTextTheme(Color color, double mainSize, double lineSpacing) {
  return TextTheme(
    displayLarge: GoogleFonts.montserrat(color: color, fontSize: mainSize+6, fontWeight: FontWeight.w500),
    displayMedium: GoogleFonts.montserrat(color: color, fontSize: mainSize+5, fontWeight: FontWeight.w500),
    displaySmall: GoogleFonts.montserrat(color: color, fontSize: mainSize+4, fontWeight: FontWeight.w500),
    headlineMedium: GoogleFonts.montserrat(color: color, fontSize: mainSize+3, fontWeight: FontWeight.w500),
    headlineSmall: GoogleFonts.montserrat(color: color, fontSize: mainSize+2, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.montserrat(color: color, fontSize: mainSize+1, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.montserrat(color: color, fontSize: mainSize, height: lineSpacing),
    titleMedium: GoogleFonts.montserrat(color: color, fontSize: mainSize),
    titleSmall: GoogleFonts.montserrat(color: color, fontSize: mainSize-2),
  );
}