import 'package:flutter/material.dart';

import 'text_theme.dart';

ThemeData buildLightTheme({
  double mainFontSize = 16,
  double lineSpacing = 1.35,
}) {
  return ThemeData(
    textTheme: buildTextTheme(Colors.black, mainFontSize, lineSpacing),
    primarySwatch: Colors.blueGrey,
    primaryColor: Colors.blueGrey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.blueGrey,
    ),
  );
}
