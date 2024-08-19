import 'package:flutter/material.dart';
import 'package:loginform/screens/home_screen.dart';
import 'package:loginform/screens/login_screen.dart';
import 'package:loginform/screens/profile_screen.dart';
import 'package:loginform/screens/signup_screen.dart'; // Misalkan Anda punya home screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,  // Matikan banner debug
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), // Layar pertama saat aplikasi diluncurkan
        '/profile': (context) => ProfileScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(), // Misalkan ada home screen setelah login berhasil
      },
    );
  }
}
