import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tebak_gambar/models/questionmodel.dart';
import 'package:tebak_gambar/utils/quizprogressmanager.dart';

class TebakGambar extends StatefulWidget {
  final String currentlevel;
  final Function(int) onProgressUpdate; // Add this line
  final String difficulty;

  const TebakGambar({super.key, required this.currentlevel, required this.onProgressUpdate, required this.difficulty});
  @override
  _TebakGambarState createState() => _TebakGambarState();
}

class _TebakGambarState extends State<TebakGambar> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _answeredCount = 0;
  Question? currentQuestion;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/utils/tebakgambar_quiz.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      // Filter questions for current level and difficulty
      _questions = jsonData
          .map((json) => Question.fromJson(json))
          .where((question) => question.level == int.parse(widget.currentlevel) && question.difficulty == widget.difficulty)
          .toList();

      setState(() {
        _isLoading = false;
        // Set currentQuestion only if questions exist for this level
        if (_questions.isNotEmpty) {
          currentQuestion = _questions[_currentQuestionIndex];
        } else {
          currentQuestion = null;
        }
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        _isLoading = false;
        currentQuestion = null;
      });
    }
  }

  // Call this when an answer is checked
  Future<void> _checkAnswer(String selectedAnswer) async {
    final isCorrect = selectedAnswer == _questions[_currentQuestionIndex].correctAnswer;
    // Increment answered questions (correct or incorrect)
    setState(() {
      _answeredCount++;
    });

    // Save to persistent storage
    int savedCount = await QuizProgressManager.getAnsweredQuestions('answered_questions_tebak_gambar');
    // await QuizProgressManager.saveAnsweredQuestions(savedCount + 1);
    await QuizProgressManager.saveAnsweredQuestions('answered_questions_tebak_gambar', savedCount + 1);

    // Notify parent page
    widget.onProgressUpdate(_answeredCount);

    // Show dialog with image and text for only 2 seconds
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          // Navigator.of(context).pop();
          // Move to the next question or reset
          if (_currentQuestionIndex < _questions.length - 1) {
            setState(() {
              _currentQuestionIndex++;
            });
          } else {
            setState(() {
              _currentQuestionIndex = 0;
            });
          }
        });

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isCorrect ? 'assets/checkanswer_icon/check_ring_round.png' : 'assets/checkanswer_icon/close_ring.png',
                height: 80.0,
                width: 80.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                isCorrect ? "Jawaban Anda benar." : "Jawaban Anda salah.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 24.0, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                "${_currentQuestionIndex + 1}/${_questions.length}",
                style: const TextStyle(
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : currentQuestion == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Data Added Yet',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Level ${widget.currentlevel} ${widget.difficulty}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Go Back'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 24.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Card(
                                elevation: 4.0,
                                color: Colors.grey[350],
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    height: 240.0,
                                    child: Center(
                                      child: Image.asset(
                                        currentQuestion.question, // Gambar dari JSON
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // Opsi Jawaban
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: currentQuestion.options.map((option) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[350], // Same color as the Card
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent, // Transparent to show Container color
                                          shadowColor: Colors.transparent, // Remove default button shadow
                                          padding: const EdgeInsets.all(16.0), // Padding inside button
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () => _checkAnswer(option),
                                        child: Center(
                                          child: Text(
                                            option,
                                            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
