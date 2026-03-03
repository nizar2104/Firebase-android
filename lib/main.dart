
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
    final baseTheme = ThemeData.dark();
    final textTheme = GoogleFonts.latoTextTheme(baseTheme.textTheme);

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFFF0000), // Rekordbox Red
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF0000), // Rekordbox Red
        secondary: Color(0xFFFFFF00), // Rekordbox Yellow
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        error: Color(0xFFFF0000), // Rekordbox Red for errors
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: Colors.white70),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, // Button text color
          backgroundColor: const Color(0xFFFFFF00), // Rekordbox Yellow
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
       radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFFFF0000); // Rekordbox Red when selected
          }
          return Colors.grey; // Grey when not selected
        }),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF00FF00) // Rekordbox Green for success icons
      ),
    );

    return MaterialApp(
      title: 'CDJ Compatibility Checker',
      theme: darkTheme,
      home: const HomePage(),
    );
  }
}
