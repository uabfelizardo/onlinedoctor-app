import 'package:flutter/material.dart';
import 'ui/auth/LoginPage.dart'; // Importe a LoginPage
import 'home_page.dart'; // Import your home page widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
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


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar para a LoginPage após 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2.0,
                ),
                image: DecorationImage(
                  image: AssetImage('onlinedoctor.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Online Doctor',
              style: TextStyle(color: Color.fromARGB(255, 135, 180, 240)),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
