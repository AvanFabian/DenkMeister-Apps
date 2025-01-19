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
  Map<int, bool> _availableLevels = {};
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
      final questions = jsonData.map((json) => Question.fromJson(json)).toList();

      // Create a map of levels that have questions
      final Map<int, bool> availableLevels = {};
      for (int i = 1; i <= 7; i++) {
        availableLevels[i] = questions.any((q) => q.level == i && q.difficulty == widget.difficulty);
      }

      setState(() {
        _availableLevels = availableLevels;
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
                      height: 1100.0,
                      fit: BoxFit.cover,
                    ),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      ...List.generate(7, (index) {
                        List<Map<String, double>> positions = [
                          {'top': -30.0, 'left': -5.0},
                          {'top': 40.0, 'right': 4.0},
                          {'top': 180.0, 'left': 28.0},
                          {'top': 310.0, 'right': -20.0},
                          {'top': 405.0, 'left': 14.0},
                          {'top': 540.0, 'right': 18.0},
                          {'top': 660.0, 'left': 32.0},
                        ];

                        final levelNumber = index + 1;
                        final hasQuestions = _availableLevels[levelNumber] ?? false;

                        return Positioned(
                          top: positions[index]['top'],
                          left: positions[index].containsKey('left') ? positions[index]['left'] : null,
                          right: positions[index].containsKey('right') ? positions[index]['right'] : null,
                          child: GestureDetector(
                            onTap: hasQuestions
                                ? () {
                                    Widget destinationPage;
                                    if (widget.quizName == "Tebak Gambar") {
                                      destinationPage =
                                          TebakGambar(currentlevel: '$levelNumber', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                                    } else if (widget.quizName == "Cocok Kata") {
                                      destinationPage =
                                          CocokKata(currentlevel: '$levelNumber', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                                    } else if (widget.quizName == "Kalimat Rumpang") {
                                      destinationPage =
                                          KalimatRumpang(currentlevel: '$levelNumber', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                                    } else if (widget.quizName == "Susun Kalimat") {
                                      destinationPage =
                                          SusunKalimat(currentlevel: '$levelNumber', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                                    } else {
                                      destinationPage =
                                          TebakGambar(currentlevel: '$levelNumber', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
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
                                    '$levelNumber',
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
