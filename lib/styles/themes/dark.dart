import 'package:flutter/material.dart';

import 'text_theme.dart';

ThemeData buildDarkTheme({
  double mainFontSize = 16,
  double lineSpacing = 1.35,
}) {
  return ThemeData(
    textTheme: buildTextTheme(Colors.white, mainFontSize, lineSpacing),
    hintColor: Colors.grey,
    appBarTheme: const AppBarTheme(
      color: Colors.black54,
    ),
    primarySwatch: Colors.blueGrey,
    primaryColor: Colors.blueGrey[600],
    scaffoldBackgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
    colorScheme: const ColorScheme.dark(
      secondary: Colors.grey,
      primary: Colors.blueGrey,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.blueGrey[400],
    ),
    toggleableActiveColor: Colors.blueGrey[300],
  );
}
