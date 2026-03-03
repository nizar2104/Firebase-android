
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';
import 'home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ScanProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the dark theme inspired by CDJ equipment
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFDF1F26), // Pioneer DJ Red
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFDF1F26), // Red
        secondary: Color(0xFFF5B50A), // Yellow
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontWeight: FontWeight.bold,
          fontSize: 36,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.orbitron(
          fontWeight: FontWeight.w500,
          fontSize: 22,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: Colors.white,
        ),
        labelLarge: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black
        )
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, // Button text color
          backgroundColor: const Color(0xFFF5B50A), // Yellow
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );

    return MaterialApp(
      title: 'CDJ Compatibility Checker',
      theme: darkTheme,
      home: const HomePage(),
    );
  }
}
