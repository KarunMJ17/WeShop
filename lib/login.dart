import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage1.dart'; // Owner's home page
import 'homepage2.dart'; // Customer's home page

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isOwner = false; // Checkbox to track Owner vs Customer

  void _loginUser() async {
    try {
      // Attempt to sign in with the provided email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If the user is successfully logged in
      if (userCredential.user != null) {
        // Navigate based on the checkbox selection (Owner or Customer)
        if (_isOwner) {
          // Navigate to HomePage1 for Owner
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage1()),
          );
        } else {
          // Navigate to HomePage2 for Customer
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage2()),
          );
        }
      }
    } catch (e) {
      _showErrorDialog('Error during login: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001A57),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Checkbox for 'Owner'
              Row(
                children: [
                  Checkbox(
                    value: _isOwner,
                    onChanged: (value) {
                      setState(() {
                        _isOwner = value ?? false;
                      });
                    },
                  ),
                  Text(
                    "Owner",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              // Checkbox for 'Customer'
              Row(
                children: [
                  Checkbox(
                    value: !_isOwner, // If _isOwner is true, customer should be false
                    onChanged: (value) {
                      setState(() {
                        _isOwner = !(value ?? false); // Toggle the _isOwner state
                      });
                    },
                  ),
                  Text(
                    "Customer",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Login button
              ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF001A57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
