import 'package:flutter/material.dart';

class Quizdashboard extends StatelessWidget {
  const Quizdashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            // Full width SizedBox with another SizedBox inside
            Container(
              width: double.infinity,
              height: 320.0,
              decoration: const BoxDecoration(
                color: Color(0xFF007BFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  // Image positioned on the right
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/logo-otak.png', // Replace with your local image path
                      width: 200.0,
                      height: 200.0,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  // Text positioned on the left
                  const Positioned(
                    left: 16.0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        'Pilih Kuis Yang\nIngin Anda Mainkan',
                        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0), // Vertical gap
            // Wrap the cards in a SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(4, (index) {
                    // List of image paths
                    final imagePaths = [
                      'assets/q1.png',
                      'assets/q2.png',
                      'assets/q3.png',
                      'assets/q4.png',
                    ];

                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              // SizedBox inside Card
                              SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Image.asset(
                                  imagePaths[index], // Use different image for each card
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Rest of the card content
                              const SizedBox(width: 32.0), // Horizontal gap
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Tebak Gambar',
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0), // Vertical gap between texts
                                    Text(
                                      'Tentukan Jawaban Sesuai Gambar',
                                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0), // Horizontal gap
                              const SizedBox(
                                width: 72.0,
                                height: 72.0,
                                child: Stack(
                                  alignment: Alignment.center, // Center all children within the Stack
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      value: 0.7, // Example progress value
                                      strokeWidth: 5.0,
                                    ),
                                    Center(
                                      child: Text(
                                        '70%', // Example percentage text
                                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );
  }
}
