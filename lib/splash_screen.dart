import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the HomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds, then start the animation and navigate
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnimated = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        // Navigate to the HomeScreen after animation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Set the background color to deep blue
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shopping bag symbol with text inside
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    scale: _isAnimated ? 5.0 : 1.0, // Scale up the icon after 2 seconds
                    duration: const Duration(seconds: 1),
                    child: Icon(
                      Icons.shopping_bag,
                      size: 140,
                      color: Colors.green, // Shopping bag icon in green
                    ),
                  ),
                  Positioned(
                    top: 60, // Adjust position of text inside the symbol
                    child: Column(
                      children: [
                        Text(
                          'WE',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text for better contrast
                            fontFamily: 'Roboto',
                            letterSpacing: 2.0, // Slight letter spacing
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'SHOP',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text for better contrast
                            fontFamily: 'Roboto',
                            letterSpacing: 2.0, // Slight letter spacing
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Space before tagline
              // Tagline
              Text(
                'Shopping made easy',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green, // Tagline text in green
                ),
              ),
              const SizedBox(height: 32), // Space before footer
              // Footer
              Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Text(
                  'Powered by RealFighters',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Footer text in white
                    fontWeight: FontWeight.w400,
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
