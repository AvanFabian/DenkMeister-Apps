// floating_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:tebak_gambar/quiz_home.dart';
import 'package:tebak_gambar/library_home.dart';
import 'package:tebak_gambar/pengaturan.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    final containerWidth = screenWidth * 0.72; // 70% of screen width
    final containerHeight = screenHeight * 0.075; // 8% of screen height
    final leftPadding = (screenWidth - containerWidth) / 2; // Center horizontally
    final bottomPadding = screenHeight * 0.04; // 4% padding from bottom

    return Positioned(
      bottom: bottomPadding,
      left: leftPadding,
      child: Container(
        height: containerHeight,
        width: containerWidth,
        constraints: const BoxConstraints(
          minHeight: 50.0,
          maxHeight: 70.0,
          minWidth: 200.0,
          maxWidth: 400.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Quizdashboard()),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.task, color: Colors.black, size: 30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Library()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black, size: 30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}