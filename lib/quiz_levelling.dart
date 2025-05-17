import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tebak_gambar/soal/cocok_kata.dart';
import 'package:tebak_gambar/soal/kalimat_rumpang.dart';
import 'package:tebak_gambar/soal/susun_kalimat.dart';
import 'package:tebak_gambar/soal/tebak_gambar.dart';
import 'package:tebak_gambar/utils/quizprogressmanager.dart';

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

  Future<bool> _isLevelCompleted(String levelMark) async {
    String quizType = 'susun_kalimat'; // Default
    if (widget.quizName == "Tebak Gambar") {
      quizType = 'tebak_gambar';
    } else if (widget.quizName == "Cocok Kata") {
      quizType = 'cocok_kata';
    } else if (widget.quizName == "Kalimat Rumpang") {
      quizType = 'kalimat_rumpang';
    }
    return await QuizProgressManager.isLevelCompleted(quizType, levelMark, widget.difficulty);
  }

  Future<bool> _isLevelAvailable(int levelNumber) async {
    if (levelNumber == 1) return true; // First level is always available

    // Check if previous level is completed
    final previousLevelMark = 'Level ${levelNumber - 1}';
    return await _isLevelCompleted(previousLevelMark);
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
      {'top': 30.0, 'right': 4.0}, // Level 2
      {'top': 130.0, 'left': 28.0}, // Level 3
      {'top': 240.0, 'right': -20.0}, // Level 4
      {'top': 320.0, 'left': 14.0}, // Level 5
      {'top': 430.0, 'right': 14.0}, // Level 6
      {'top': 530.0, 'left': 16.0}, // Level 7
      {'top': 640.0, 'right': -10.0}, // Level 8
      {'top': 746.0, 'left': 0.0}, // Level 9
      {'top': 846.0, 'right': -20.0}, // Level 10
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
                style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
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
                      height: 900.0,
                    ),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ...List.generate(10, (index) {
                        final levelMark = 'Level ${index + 1}';
                        final hasQuestions = _availableLevels[levelMark] ?? false;
                        final isComingSoon = index >= 5;

                        return Positioned(
                          top: positions[index]['top'],
                          left: positions[index].containsKey('left') ? positions[index]['left'] : null,
                          right: positions[index].containsKey('right') ? positions[index]['right'] : null,
                          child: FutureBuilder<bool>(
                            future: _isLevelCompleted(levelMark),
                            builder: (context, snapshot) {
                              final isCompleted = snapshot.data ?? false;
                              return FutureBuilder<bool>(
                                future: _isLevelAvailable(index + 1),
                                builder: (context, availabilitySnapshot) {
                                  final isAvailable = availabilitySnapshot.data ?? false;
                                  return GestureDetector(
                                    onTap: () {
                                      if (isComingSoon) {
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
                                      } else if (isCompleted) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: const Text(
                                              'Level ini sudah selesai!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18.0, fontFamily: 'Raleway'),
                                            ),
                                          ),
                                        );
                                      } else if (!isAvailable) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: const Text(
                                              'Selesaikan level sebelumnya terlebih dahulu!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18.0, fontFamily: 'Raleway'),
                                            ),
                                          ),
                                        );
                                      } else if (hasQuestions) {
                                        Widget destinationPage;
                                        if (widget.quizName == "Tebak Gambar") {
                                          destinationPage = TebakGambar(
                                              currentlevel: '${index + 1}',
                                              onProgressUpdate: _onProgressUpdate,
                                              difficulty: widget.difficulty,
                                              levelMark: levelMark);
                                        } else if (widget.quizName == "Cocok Kata") {
                                          destinationPage = CocokKata(
                                              currentlevel: '${index + 1}',
                                              onProgressUpdate: _onProgressUpdate,
                                              difficulty: widget.difficulty,
                                              levelMark: levelMark);
                                        } else if (widget.quizName == "Kalimat Rumpang") {
                                          destinationPage = KalimatRumpang(
                                              currentlevel: '${index + 1}',
                                              onProgressUpdate: _onProgressUpdate,
                                              difficulty: widget.difficulty,
                                              levelMark: levelMark);
                                        } else if (widget.quizName == "Susun Kalimat") {
                                          destinationPage = SusunKalimat(
                                              currentlevel: '${index + 1}',
                                              onProgressUpdate: _onProgressUpdate,
                                              difficulty: widget.difficulty,
                                              levelMark: levelMark);
                                        } else {
                                          destinationPage = TebakGambar(
                                              currentlevel: '${index + 1}',
                                              onProgressUpdate: _onProgressUpdate,
                                              difficulty: widget.difficulty,
                                              levelMark: levelMark);
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => destinationPage),
                                        );
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: isCompleted
                                          ? const Color(0xFF007BFF)
                                          : (!isAvailable || !hasQuestions || isComingSoon)
                                              ? Colors.grey[300]
                                              : const Color(0xFFD9D9D9),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: isCompleted ? Colors.white : Colors.black,
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Raleway',
                                            ),
                                          ),
                                          if (!isAvailable || !hasQuestions || isComingSoon)
                                            const Icon(
                                              Icons.lock,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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
