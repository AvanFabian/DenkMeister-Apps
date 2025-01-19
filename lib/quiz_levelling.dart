import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tebak_gambar/models/questionmodel.dart';
import 'package:tebak_gambar/soal/cocok_kata.dart';
import 'package:tebak_gambar/soal/kalimat_rumpang.dart';
// import 'package:tebak_gambar/quizprogressmanager.dart';
import 'package:tebak_gambar/soal/susun_kalimat.dart';
import 'package:tebak_gambar/soal/tebak_gambar.dart';

class QuizLevelling extends StatefulWidget {
  final String quizName;
  final String difficulty;

  const QuizLevelling({super.key, required this.quizName, required this.difficulty});

  @override
  _QuizLevellingState createState() => _QuizLevellingState();
}

class _QuizLevellingState extends State<QuizLevelling> {
  Map<String, bool> _availableLevels = {};
  Map<String, String> _levelMarks = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAvailableLevels();
  }

  Future<void> _checkAvailableLevels() async {
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

      // Create maps for available levels and their marks
      final Map<String, bool> availableLevels = {};
      final Map<String, String> levelMarks = {};

      // Get unique level marks from questions
      for (final question in jsonData) {
        final String levelMark = question['levelmark'] ?? 'Level ${question['level']}';
        availableLevels[levelMark] = true;
        levelMarks[levelMark] = levelMark;
      }

      setState(() {
        _availableLevels = availableLevels;
        _levelMarks = levelMarks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking available levels: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onProgressUpdate(int answeredCount) {
    // Update progress in this page if needed
    print('Progress updated: $answeredCount questions answered.');
  }

  @override
  Widget build(BuildContext context) {
    // Define positions for 5 levels
    final List<Map<String, double>> positions = [
      {'top': -30.0, 'left': -5.0}, // Level 1
      {'top': 120.0, 'right': 4.0}, // Level 2
      {'top': 270.0, 'left': 28.0}, // Level 3
      {'top': 420.0, 'right': -20.0}, // Level 4
      {'top': 570.0, 'left': 14.0}, // Level 5
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24.0, color: Colors.white),
            onPressed: () => Navigator.pop(context),
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
              const SizedBox(height: 56.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/jalur-leveling.png',
                      height: 800.0, // Reduced height for 5 levels
                      fit: BoxFit.cover,
                    ),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ...List.generate(5, (index) {
                        final levelMark = 'Level ${index + 1}';
                        final hasQuestions = _availableLevels[levelMark] ?? false;

                        return Positioned(
                          top: positions[index]['top'],
                          left: positions[index].containsKey('left') ? positions[index]['left'] : null,
                          right: positions[index].containsKey('right') ? positions[index]['right'] : null,
                          child: GestureDetector(
                            onTap: hasQuestions
                                ? () {
                                    Widget destinationPage;
                                    final levelMark = 'Level ${index + 1}';
                                    if (widget.quizName == "Tebak Gambar") {
                                      destinationPage =
                                          TebakGambar(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty, levelMark: levelMark);
                                    } else if (widget.quizName == "Cocok Kata") {
                                      destinationPage =
                                          CocokKata(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty, levelMark: levelMark);
                                    } else if (widget.quizName == "Kalimat Rumpang") {
                                      destinationPage =
                                          KalimatRumpang(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty, levelMark: levelMark);
                                    } else if (widget.quizName == "Susun Kalimat") {
                                      destinationPage =
                                          SusunKalimat(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty, levelMark: levelMark);
                                    } else {
                                      destinationPage =
                                          TebakGambar(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty, levelMark: levelMark);
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => destinationPage),
                                    );
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: 40.0,
                              backgroundColor: hasQuestions ? const Color(0xFFD9D9D9) : Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(color: hasQuestions ? Colors.black : Colors.grey[600], fontSize: 28.0, fontWeight: FontWeight.bold),
                                  ),
                                  if (!hasQuestions)
                                    const Icon(
                                      Icons.lock,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                ],
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
