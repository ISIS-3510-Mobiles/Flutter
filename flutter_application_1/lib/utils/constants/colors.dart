import 'package:flutter/material.dart';

class TColors{
  TColors._();

  // App basic colors
  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  // Gradient
  static const Gradient linerGradient = LinearGradient(
      begin: Alignment(0, 0),
      end:  Alignment(0.707, -0.707),
      colors: [
        Colors.green,
        Colors.blue,
      ],
  );

  // Text Colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color textWhite = Colors.white;

  // Background
  static const Color light = Color(0xFF4b68ff);
  static const Color dark = Color(0xFFFFE24B);
  static const Color primaryBackground = Colors.white;

  // Background Container
  static const Color lightContainer = Color(0xFF4b68ff);
  static  Color darkContainer = Colors.white.withOpacity(0.1);

  // Button
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFFFFE24B);
  static const Color buttonDisabled = Color(0xFFFFE24B);

  // Border
  static const Color borderPrimary = Color(0xFF4b68ff);
  static const Color borderSecondary = Color(0xFFFFE24B);

  // Error and validation
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.yellow;
  static const Color info = Colors.blue;
}