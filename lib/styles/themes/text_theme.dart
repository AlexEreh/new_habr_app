import 'package:flutter/material.dart';

TextTheme buildTextTheme(Color color, double mainSize, double lineSpacing) {
  return TextTheme(
    displayLarge: TextStyle(color: color, fontSize: mainSize+6, fontWeight: FontWeight.w500),
    displayMedium: TextStyle(color: color, fontSize: mainSize+5, fontWeight: FontWeight.w500),
    displaySmall: TextStyle(color: color, fontSize: mainSize+4, fontWeight: FontWeight.w500),
    headlineMedium: TextStyle(color: color, fontSize: mainSize+3, fontWeight: FontWeight.w500),
    headlineSmall: TextStyle(color: color, fontSize: mainSize+2, fontWeight: FontWeight.w500),
    titleLarge: TextStyle(color: color, fontSize: mainSize+1, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(color: color, fontSize: mainSize, height: lineSpacing),
    titleMedium: TextStyle(color: color, fontSize: mainSize),
    titleSmall: TextStyle(color: color, fontSize: mainSize-2),
  );
}