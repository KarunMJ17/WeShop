import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user ID (user must be logged in)
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // If no user is logged in, show an error or prompt to log in
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Text('Please log in to view your profile'),
        ),
      );
    }

    // Fetch user data from Firebase Realtime Database
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final userRef = _database.child('users').child(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DataSnapshot>(
        future: userRef.get(),  // Get the data for the logged-in user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User profile not found.'));
          }

          // Get the user data from the snapshot
          var userData = snapshot.data!.value as Map<dynamic, dynamic>;
          String fullName = userData['fullName'] ?? 'Not Available';
          String mobileNumber = userData['mobileNumber'] ?? 'Not Available';
          String email = userData['email'] ?? 'Not Available';
          String dob = userData['dateOfBirth'] ?? 'Not Available';
          String role = userData['role'] ?? 'Not Available';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name: $fullName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Phone Number: $mobileNumber',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Date of Birth: $dob',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Role: $role',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
