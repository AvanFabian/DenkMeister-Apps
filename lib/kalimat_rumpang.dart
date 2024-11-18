import 'package:flutter/material.dart';

class KalimatRumpang extends StatelessWidget {
  final String currentlevel;
  const KalimatRumpang({super.key, required this.currentlevel});

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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0), // Set the border color and width
                borderRadius: const BorderRadius.all(Radius.circular(16.0)), // Optional: Add border radius
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Optional: Add padding inside the border
              child: const Text(
                "1/20",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
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

                      // SizedBox containing a centered image
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0, left: 24.0),
                        child: Card(
                          elevation: 4.0,
                          color: Colors.grey[350], // Set the background color here
                          child: const Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            child: SizedBox(
                              height: 200.0, // Increased the height
                              child: Center(
                                child: Text(
                                  "Ayah :",
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0), // Corrected the typo in height

                      // List of Quizzes Section
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: List.generate(4, (index) {
                            final List<String> quizNames = [
                              'Pemula',
                              'Menengah',
                              'Mahir',
                              'Expert',
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Card(
                                elevation: 4.0,
                                color: Colors.grey[350], // Set the background color here
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      // Column for the texts on the left side
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                quizNames[index],
                                                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                              ),
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
