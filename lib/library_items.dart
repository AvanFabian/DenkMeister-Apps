import 'package:flutter/material.dart';

class DetailLibraryItems extends StatelessWidget {
  final String kategori;

  const DetailLibraryItems({super.key, required this.kategori});

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
              kategori,
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Scrollable content area
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 24.0),

                // List of Quizzes Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(8, (index) {
                        final List<String> imagePaths = [
                          'assets/q1.png',
                          'assets/q2.png',
                          'assets/q3.png',
                          'assets/q4.png',
                          'assets/q4.png',
                          'assets/q4.png',
                          'assets/q4.png',
                          'assets/q4.png',
                        ];

                        final List<String> quizNames = [
                          'Number & Colors',
                          'Family Members',
                          'Days of the Week and Months',
                          'Foods and Drinks',
                          'Basic Verbs',
                          'Everyday Items',
                          'Common Animals',
                          'Buildings and Places in Town',
                          'Basic Greetings and Phrases',
                          'Adjectives & Adverbs',
                        ];

                        final List<String> quizDescriptions = [
                          '200 Words',
                          '100 words',
                          '300 words',
                          '100 words',
                          '100 words',
                          '100 words',
                          '100 words',
                          '100 words',
                          '100 words',
                          '100 words',
                        ];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 42.0,
                                    height: 42.0,
                                    child: Image.asset(
                                      imagePaths[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          quizNames[index],
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        // const SizedBox(height: 2.0),
                                        Text(
                                          quizDescriptions[index],
                                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index < 7) // Add a bottom border except for the last item
                              Divider(
                                color: Colors.grey.withOpacity(0.5),
                                thickness: 1.0,
                                indent: 16.0,
                                endIndent: 16.0,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 80.0), // Add spacing to account for the bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
