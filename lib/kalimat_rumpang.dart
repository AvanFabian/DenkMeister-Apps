import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tebak_gambar/models/questionmodel.dart';

class KalimatRumpang extends StatefulWidget {
  final String currentlevel;

  const KalimatRumpang({super.key, required this.currentlevel});

  @override
  _KalimatRumpangState createState() => _KalimatRumpangState();
}

class _KalimatRumpangState extends State<KalimatRumpang> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((questions) {
      setState(() {
        // Filter questions based on the level from widget.currentLevel
        _questions = questions
            .where((q) => q.level == int.parse(widget.currentlevel))
            .toList();
      });
    });
  }

  Future<List<Question>> loadQuestions() async {
    final data = await rootBundle.loadString('assets/utils/kalimatrumpang_quiz.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((json) => Question.fromJson(json)).toList();
  }

  void _checkAnswer(String selectedAnswer) {
    final isCorrect = selectedAnswer == _questions[_currentQuestionIndex].correctAnswer;

    // Show dialog with feedback for 2 seconds
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();

          // Navigate to the next question or reset if at the last question
          if (_currentQuestionIndex < _questions.length - 1) {
            setState(() {
              _currentQuestionIndex++;
            });
          } else {
            // Reset the quiz or show completion message
            setState(() {
              _currentQuestionIndex = 0;
            });
          }
        });

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 80.0,
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
            child: SingleChildScrollView(
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
                        child: Text(
                          currentQuestion.question, // Question text
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Answer Options
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