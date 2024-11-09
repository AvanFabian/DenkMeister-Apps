import 'package:flutter/material.dart';
import 'package:tebak_gambar/quizdashboard.dart';
import 'package:tebak_gambar/library.dart';

class Difficulty extends StatelessWidget {
  final String quizName;

  const Difficulty({super.key, required this.quizName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24.0, // Set the size of the icon
              color: Colors.white, // Set the color of the icon to white
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: [
            const Spacer(), // Pushes the title to the right
            Text(
              quizName,
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Scrollable content area
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 24.0),

                      // Kosakata Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pilih Tingkatan',
                            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // List of Quizzes Section
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: List.generate(3, (index) {
                            // List of image paths
                            final imagePaths = [
                              'assets/q1.png',
                              'assets/q2.png',
                              'assets/q3.png',
                            ];

                            final List<String> quizNames = [
                              'Share',
                              'Sound',
                              'About Us',
                            ];

                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                              child: Card(
                                elevation: 4.0,
                                color: Colors.blue[50], // Set the background color here
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 16.0, right: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      // SizedBox inside Card
                                      SizedBox(
                                        width: 36.0,
                                        height: 36.0,
                                        child: Image.asset(
                                          imagePaths[index], // Use different image for each card
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Rest of the card content
                                      const SizedBox(width: 16.0), // Horizontal gap
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              quizNames[index],
                                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 80.0), // Add spacing to account for the bottom button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
