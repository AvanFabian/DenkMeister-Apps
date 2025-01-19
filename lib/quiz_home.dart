import 'package:flutter/material.dart';
import 'package:tebak_gambar/utils/quizprogressmanager.dart';
import 'package:tebak_gambar/quiz_tingkat_kesulitan.dart';
import 'package:tebak_gambar/utils/floating_navbar.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class QuizDataLoader {
  static Future<int> getTotalQuestions(String jsonFilePath) async {
    final String response = await rootBundle.loadString(jsonFilePath);
    final List<dynamic> data = json.decode(response);
    return data.length;
  }
}

class Quizdashboard extends StatefulWidget {
  const Quizdashboard({super.key});

  @override
  _QuizdashboardState createState() => _QuizdashboardState();
}

class _QuizdashboardState extends State<Quizdashboard> {
  final Map<String, int> _answeredCounts = {
    'tebak_gambar': 0,
    'cocok_kata': 0,
    'kalimat_rumpang': 0,
    'susun_kalimat': 0,
  };

  final Map<String, int> _totalQuestions = {
    'tebak_gambar': 0,
    'cocok_kata': 0,
    'kalimat_rumpang': 0,
    'susun_kalimat': 0,
  };

  final Map<String, double> _progressValues = {
    'tebak_gambar': 0.0,
    'cocok_kata': 0.0,
    'kalimat_rumpang': 0.0,
    'susun_kalimat': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      await Future.wait([
        _loadQuizProgress(
          jsonFilePath: 'assets/utils/tebakgambar_quiz.json',
          answeredKey: QuizProgressManager.answeredQuestionsTebakGambarKey,
          quizType: 'tebak_gambar',
        ),
        _loadQuizProgress(
          jsonFilePath: 'assets/utils/cocokkata_quiz.json',
          answeredKey: QuizProgressManager.answeredQuestionsCocokKataKey,
          quizType: 'cocok_kata',
        ),
        _loadQuizProgress(
          jsonFilePath: 'assets/utils/kalimatrumpang_quiz.json',
          answeredKey: QuizProgressManager.answeredQuestionsKalimatRumpangKey,
          quizType: 'kalimat_rumpang',
        ),
        _loadQuizProgress(
          jsonFilePath: 'assets/utils/susunkalimat_quiz.json',
          answeredKey: QuizProgressManager.answeredQuestionsSusunKalimatKey,
          quizType: 'susun_kalimat',
        ),
      ]);
    } catch (e) {
      print("Error loading quiz data: $e");
    }
  }

  Future<void> _loadQuizProgress({
    required String jsonFilePath,
    required String answeredKey,
    required String quizType,
  }) async {
    final totalQuestions = await _getQuestionCount(jsonFilePath);
    final answeredQuestions = await QuizProgressManager.getAnsweredQuestions(answeredKey);

    setState(() {
      _totalQuestions[quizType] = totalQuestions;
      _answeredCounts[quizType] = answeredQuestions;
      _progressValues[quizType] = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
    });
  }

  Future<int> _getQuestionCount(String jsonFilePath) async {
    final String response = await rootBundle.loadString(jsonFilePath);
    final List<dynamic> data = json.decode(response);
    return data.length;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the available space
        children: [
          // Top blue container
          Container(
            width: double.infinity,
            height: 200.0,
            decoration: const BoxDecoration(
              color: Color(0xFF007BFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 0,
                  top: 0,
                  // bottom: 420,
                  bottom: screenHeight * 0.49,
                  child: SizedBox(
                    width: screenWidth * 0.40, // 45% of screen width
                    height: screenHeight * 0.10, // 20% of screen height
                    child: Image.asset(
                      'assets/german-flag.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Positioned(
                  left: 16.0,
                  top: 0,
                  bottom: 470,
                  child: Center(
                    child: Text(
                      'Pilih Kuis Yang Ingin\n Kamu Mainkan',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content container
          Positioned(
            top: 275,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 116.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Column(
                    children: List.generate(4, (index) {
                      final imagePaths = [
                        'assets/q1.png',
                        'assets/q2.png',
                        'assets/q3.png',
                        'assets/q4.png',
                      ];

                      final List<String> quizNames = [
                        'Tebak Gambar',
                        'Cocok Kata',
                        'Kalimat Rumpang',
                        'Susun Kalimat',
                      ];

                      final List<String> quizType = [
                        'answered_questions_tebak_gambar',
                        'answered_questions_cocok_kata',
                        'answered_questions_kalimat_rumpang',
                        'answered_questions_susun_kalimat',
                      ];

                      final List<String> quizDescriptions = [
                        'Tentukan Jawaban Sesuai Gambar',
                        'Temukan Pasangan Kata',
                        'Lengkapi Kalimat Yang Rumpang',
                        'Rangkai Kata Menjadi Kalimat',
                      ];

                      final double progressValue = _progressValues[quizType[index]] ?? 0.0;
                      final int percentage = (progressValue * 100).toInt();

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TingkatKesulitan(
                                  quizName: quizNames[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4.0,
                            color: Colors.blue[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0), // Adjusted border radius
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 24.0,
                                bottom: 24.0,
                                left: 16.0,
                                right: 16.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Image.asset(
                                      imagePaths[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 32.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          quizNames[index],
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          quizDescriptions[index],
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  SizedBox(
                                    width: 72.0,
                                    height: 72.0,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 48.0,
                                          height: 48.0,
                                          child: CircularProgressIndicator(
                                            value: progressValue,
                                            strokeWidth: 4.0,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '$percentage%',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
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
              ),
            ),
          ),
          // Floating Navigation Bar
          const FloatingNavBar(),
        ],
      ),
    );
  }
}
