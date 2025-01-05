import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'login.dart'; // Importing Login screen
import 'signup.dart'; // Importing Signup screen
import 'splash_screen.dart'; // Import SplashScreen here

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized first
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Set SplashScreen as the home screen
      routes: {
        '/login': (context) =>  LoginScreen(),  // Define route for Login screen
        '/signup': (context) =>  SignUpScreen(),  // Define route for Signup screen
      },
    );
  }
}
