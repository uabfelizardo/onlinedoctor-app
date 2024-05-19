import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your home page widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: mainTheme,
      home: const MyHomePage(),
    );
  }
}

// Define your custom theme
final ThemeData mainTheme = ThemeData(
  primaryColor: const Color(0xFF63B2A9),
  fontFamily: "",
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF63B2A9),
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF63B2A9),
    foregroundColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey; // Disabled color
        }
        return const Color(0xFF63B2A9); // Enabled color
      }),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
    ),
  ),
);


