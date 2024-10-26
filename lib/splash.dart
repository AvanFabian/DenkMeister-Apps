import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding.dart'; // Import the OnBoardingPage

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 175.0,
              height: 175.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Denkmaster',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
