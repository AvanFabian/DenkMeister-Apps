import 'package:flutter/material.dart';
import 'package:tebak_gambar/quizlevelling_a1.dart';
import 'package:tebak_gambar/quizlevelling_a2.dart';
import 'package:tebak_gambar/quizlevelling_b1.dart';

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
              size: 24.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: [
            const Spacer(),
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
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 24.0),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: List.generate(3, (index) {
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

                            // Define a list of colors for each difficulty level
                            final List<Color> cardColors = [
                              const Color(0xFFEBFFFB), // Color for Tingkat A1
                              const Color(0xFFFFF8E5), // Color for Tingkat A2
                              const Color(0xFFFFE5E5), // Color for Tingkat B1
                            ];

                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the respective screen based on quizDescriptions
                                  if (quizDescriptions[index] == 'Tingkat A1') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => QuizLevellingA1(quizName: quizName)),
                                    );
                                  } else if (quizDescriptions[index] == 'Tingkat A2') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => QuizLevellingA2(quizName: quizName)),
                                    );
                                  } else if (quizDescriptions[index] == 'Tingkat B1') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => QuizLevellingB1(quizName: quizName)),
                                    );
                                  }
                                },
                                child: Card(
                                  elevation: 4.0,
                                  color: cardColors[index], // Apply different color based on index
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                quizNames[index],
                                                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                quizDescriptions[index],
                                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 36.0,
                                          height: 36.0,
                                          child: Image.asset(
                                            imagePaths[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 80.0),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'assets/bg-diffculty.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 275.0,
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
