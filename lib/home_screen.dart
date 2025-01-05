import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set the background image here
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_images.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Title at the top
              Positioned(
                top: 50, // Adjust top position as needed
                left: 20,
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Login button
              Positioned(
                top: 353, // Move the Login button down by 150 pixels
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Login screen
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              // Signup button
              Positioned(
                top: 464, // Move the Signup button down by 220 pixels
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Signup screen
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
