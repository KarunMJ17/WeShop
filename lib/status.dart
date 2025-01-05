import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Page'),
        backgroundColor: Color(0xFF001A57),
      ),
      body: Center(
        child: Text(
          'This is the Status Page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
