import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // <<== Importer Google Fonts
import 'screens/economic_calendar_screen.dart';
import 'screens/news_screen.dart';
import 'screens/home_screen.dart'; // Ajout de l'import corrigé

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invest IA',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/economic_calendar': (context) => EconomicCalendarScreen(),
        '/news': (context) => NewsScreen(),
      },
    );
  }
}
