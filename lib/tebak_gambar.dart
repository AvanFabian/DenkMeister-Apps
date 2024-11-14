import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tebak_gambar/models/questionmodel.dart';

class TebakGambar extends StatefulWidget {
  const TebakGambar({super.key});

  @override
  _TebakGambarState createState() => _TebakGambarState();
}

class _TebakGambarState extends State<TebakGambar> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((questions) {
      setState(() {
        // Filter hanya untuk soal TEBAK_GAMBAR
        _questions = questions.where((q) => q.type == "TEBAK_GAMBAR").toList();
      });
    });
  }

  Future<List<Question>> loadQuestions() async {
    final data = await rootBundle.loadString('utils/questions.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((json) => Question.fromJson(json)).toList();
  }

  void _checkAnswer(String selectedAnswer) {
    final isCorrect = selectedAnswer == _questions[_currentQuestionIndex].correctAnswer;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? "Benar!" : "Salah!"),
          content: Text(isCorrect ? "Jawaban Anda benar." : "Jawaban Anda salah."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Maju ke soal berikutnya jika ada
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                } else {
                  // Reset atau selesai
                  setState(() {
                    _currentQuestionIndex = 0;
                  });
                }
              },
              child: const Text("Lanjut"),
            ),
          ],
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
