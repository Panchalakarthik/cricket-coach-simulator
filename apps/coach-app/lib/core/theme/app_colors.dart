import 'package:flutter/material.dart';

// Design tokens matching the CricCoach production app aesthetic
const kBackground = Color(0xFF0A0E17);
const kSurface = Color(0xFF111827);
const kSurfaceElevated = Color(0xFF1A2235);
const kBorder = Color(0xFF1F2937);

const kTeal = Color(0xFF4AEAC4);
const kTealDim = Color(0xFF1A4A40);
const kGold = Color(0xFFD97706);
const kGoldDim = Color(0xFF3D2A00);

const kLive = Color(0xFFFF4D6D);
const kLiveDim = Color(0xFF3D0A18);

const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = Color(0xFF9CA3AF);
const kTextMuted = Color(0xFF4B5563);

const kPressureHigh = Color(0xFFEF4444);
const kPressureMid = Color(0xFFD97706);
const kPressureLow = Color(0xFF4AEAC4);
const kMomentumColor = Color(0xFF818CF8);

const kSuccessGreen = Color(0xFF22C55E);
const kWarningAmber = Color(0xFFF59E0B);

ThemeData buildAppTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBackground,
      colorScheme: const ColorScheme.dark(
        primary: kTeal,
        secondary: kGold,
        surface: kSurface,
        onPrimary: Color(0xFF0A0E17),
        onSurface: kTextPrimary,
      ),
      fontFamily: 'Roboto',
      cardTheme: CardTheme(
        color: kSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: kBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kBackground,
        foregroundColor: kTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
