import 'package:flutter/material.dart';
import 'package:tebak_gambar/cocok_kata.dart';
import 'package:tebak_gambar/kalimat_rumpang.dart';
import 'package:tebak_gambar/susun_kalimat.dart';
import 'package:tebak_gambar/tebak_gambar.dart';


class QuizLevellingB1 extends StatelessWidget {
  final String quizName;
  const QuizLevellingB1({super.key, required this.quizName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // bgcolor with value
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Pilih Level',
                style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 56.0), // Add some space between the text and the image
              Container(
                padding: const EdgeInsets.all(16.0), // Add padding around the Stack
                child: Stack(
                  clipBehavior: Clip.none, // Allow overflow
                  children: [
                    Image.asset(
                      'assets/jalur-leveling.png', // Replace with your image asset path
                      height: 1100.0, // Adjust the height as needed
                      fit: BoxFit.cover,
                    ),
                    ...List.generate(7, (index) {
                      // List of positions for each button
                      List<Map<String, double>> positions = [
                        {'top': -30.0, 'left': -5.0},
                        {'top': 40.0, 'right': 4.0},
                        {'top': 180.0, 'left': 28.0},
                        {'top': 310.0, 'right': -20.0},
                        {'top': 405.0, 'left': 14.0},
                        {'top': 540.0, 'right': 18.0},
                        {'top': 660.0, 'left': 32.0},
                      ];

                      return Positioned(
                        top: positions[index]['top'],
                        left: positions[index].containsKey('left') ? positions[index]['left'] : null,
                        right: positions[index].containsKey('right') ? positions[index]['right'] : null,
                        child: GestureDetector(
                          onTap: () {
                            // Determine which page to navigate to based on the quizName parameter
                            Widget destinationPage;
                            if (quizName == "Tebak Gambar") {
                              destinationPage = TebakGambar(currentlevel: '${index + 1}');
                            } else if (quizName == "Cocok Kata") {
                              destinationPage = CocokKata(currentlevel: '${index + 1}');
                            } else if (quizName == "Kalimat Rumpang") {
                              destinationPage = KalimatRumpang(currentlevel: '${index + 1}');
                            } else if (quizName == "Susun Kalimat") {
                              destinationPage = SusunKalimat(currentlevel: '${index + 1}');
                            } else {
                              // Default page or error handling, if needed
                              destinationPage = TebakGambar(currentlevel: '${index + 1}');
                            }

                            // Navigate to the selected page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => destinationPage),
                            );
                          },
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: const Color(0xFFD9D9D9),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
