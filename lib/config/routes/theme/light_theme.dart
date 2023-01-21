import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.white,
    ),
    actionsIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: GoogleFonts.bitterTextTheme(),
);
