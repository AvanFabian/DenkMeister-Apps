import 'package:flutter/material.dart';
import 'dart:async';
import '../onboarding.dart'; // Import the OnBoardingPage

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to OnBoardingPage after 3 seconds
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF007BFF), // Use the hex color code here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Replace Container and Text with Image
            Image.asset(
              'assets/logo-denkmeister.png', // Replace with your image path
              width: 200.0,
              height: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
