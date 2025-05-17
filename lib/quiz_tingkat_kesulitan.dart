import 'package:flutter/material.dart';
import 'package:tebak_gambar/quiz_levelling.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class TingkatKesulitan extends StatefulWidget {
  final String quizName;

  const TingkatKesulitan({super.key, required this.quizName});

  @override
  State<TingkatKesulitan> createState() => _TingkatKesulitanState();
}

class _TingkatKesulitanState extends State<TingkatKesulitan> {
  Map<String, bool> _availableDifficulties = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAvailableDifficulties();
  }

  Future<void> _checkAvailableDifficulties() async {
    try {
      String jsonPath;
      if (widget.quizName == "Tebak Gambar") {
        jsonPath = 'assets/utils/tebakgambar_quiz.json';
      } else if (widget.quizName == "Cocok Kata") {
        jsonPath = 'assets/utils/cocokkata_quiz.json';
      } else if (widget.quizName == "Kalimat Rumpang") {
        jsonPath = 'assets/utils/kalimatrumpang_quiz.json';
      } else if (widget.quizName == "Susun Kalimat") {
        jsonPath = 'assets/utils/susunkalimat_quiz.json';
      } else {
        jsonPath = 'assets/utils/tebakgambar_quiz.json';
      }

      final String jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      // Create map for available difficulties
      final Map<String, bool> availableDifficulties = {};

      // Check which difficulties have questions
      for (final question in jsonData) {
        final String difficulty = question['difficulty'] ?? 'A1';
        availableDifficulties[difficulty] = true;
      }

      setState(() {
        _availableDifficulties = availableDifficulties;
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking available difficulties: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              widget.quizName,
              style: const TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
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
                            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: List.generate(2, (index) {
                            final imagePaths = [
                              'assets/Medal-bronze.png',
                              'assets/Medal-silver.png',
                            ];

                            final List<String> quizNames = [
                              'Pemula',
                              'Menengah',
                            ];

                            final List<String> quizDifficulty = [
                              'A1',
                              'A2',
                            ];

                            final List<Color> cardColors = [
                              const Color(0xFFEBFFFB), // Color for A1
                              const Color(0xFFFFF8E5), // Color for A2
                              const Color(0xFFFFE5E5), // Color for B1
                            ];

                            final bool isAvailable = _availableDifficulties[quizDifficulty[index]] ?? false;

                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (!isAvailable) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: const Text(
                                          'Coming Soon!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18.0, fontFamily: 'Raleway'),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => QuizLevelling(quizName: widget.quizName, difficulty: quizDifficulty[index])),
                                  );
                                },
                                child: Card(
                                  elevation: 4.0,
                                  color: isAvailable ? cardColors[index] : Colors.grey[300],
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
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Raleway',
                                                  color: isAvailable ? Colors.black : Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                quizDifficulty[index],
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Raleway',
                                                  color: isAvailable ? Colors.black : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            SizedBox(
                                              width: 36.0,
                                              height: 36.0,
                                              child: Image.asset(
                                                imagePaths[index],
                                                fit: BoxFit.cover,
                                                color: isAvailable ? null : Colors.grey,
                                              ),
                                            ),
                                            if (!isAvailable)
                                              const Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Icon(
                                                  Icons.lock,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          ],
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
