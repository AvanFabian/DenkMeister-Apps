import 'package:flutter/material.dart';

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
                              'assets/Medal-bronze.png',
                              'assets/Medal-silver.png',
                              'assets/Medal-gold.png',
                            ];

                            final List<String> quizNames = [
                              'Pemula',
                              'Menengah',
                              'Mahir',
                            ];

                            final List<String> quizDescriptions = [
                              'Tingkat A1',
                              'Tingkat A2',
                              'Tingkat B1',
                            ];

                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                              child: Card(
                                elevation: 4.0,
                                color: Colors.blue[50], // Set the background color here
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      // Column for the texts on the left side
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              quizNames[index],
                                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8.0), // Vertical gap between texts
                                            Text(
                                              quizDescriptions[index],
                                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Image on the right side
                                      SizedBox(
                                        width: 36.0,
                                        height: 36.0,
                                        child: Image.asset(
                                          imagePaths[index], // Use different image for each card
                                          fit: BoxFit.cover,
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
                // Background image at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: 0.7, // Adjust the opacity value as needed (0.0 to 1.0)
                    child: Image.asset(
                      'assets/bg-diffculty.png', // Path to your background image
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 275.0, // Adjust the height as needed
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
