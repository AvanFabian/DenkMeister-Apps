import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SusunKalimat extends StatefulWidget {
  final String currentlevel;
  final Function(int) onProgressUpdate; // Add this line
  final String difficulty;

  const SusunKalimat({super.key, required this.currentlevel, required this.onProgressUpdate, required this.difficulty});

  @override
  _SusunKalimatState createState() => _SusunKalimatState();
}

class _SusunKalimatState extends State<SusunKalimat> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  List<String> _selectedWords = [];
  List<String> _correctOrder = [];
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((questions) {
      setState(() {
        _questions = questions.where((q) => q['level'] == int.parse(widget.currentlevel) && q['difficulty'] == widget.difficulty).toList();
      });
    });
  }

  Future<List<dynamic>> loadQuestions() async {
    final data = await rootBundle.loadString('assets/utils/susunkalimat_quiz.json');
    return json.decode(data);
  }

  void _checkAnswer() {
    bool isCorrect = _selectedWords.join(' ') == _correctOrder.join(' ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();

          if (_currentQuestionIndex < _questions.length - 1) {
            setState(() {
              _currentQuestionIndex++;
              _selectedWords = [];
              _showHint = false;
            });
          } else {
            setState(() {
              _currentQuestionIndex = 0;
              _selectedWords = [];
              _showHint = false;
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
                isCorrect ? "Susunan benar!" : "Susunan salah.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addWord(String word) {
    setState(() {
      _selectedWords.add(word);
    });
  }

  // Helper method for building each option
  Widget _buildOption(String option) {
    return GestureDetector(
      onTap: () => _addWord(option),
      child: Text(
        option,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _removeWord(int index) {
    setState(() {
      _selectedWords.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    _correctOrder = List<String>.from(currentQuestion['correctOrder']);

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
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align to the right
            children: [
              IconButton(
                icon: Icon(Icons.lightbulb_circle_outlined, size: 48.0, color: Colors.grey[700]),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.yellow[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lightbulb, size: 48.0, color: Colors.amber),
                            const SizedBox(height: 16.0),
                            Text(
                              currentQuestion['answerClue'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 4.0,
              color: Colors.grey[350],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQuestion['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Selected words
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: _selectedWords.asMap().entries.map((entry) {
              int index = entry.key;
              String word = entry.value;

              return Chip(
                label: Text(word, style: const TextStyle(fontSize: 18.0)),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => _removeWord(index),
              );
            }).toList(),
          ),
          const SizedBox(height: 24.0),
          // const Spacer(),
          // Word options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First two options
                      _buildOption(currentQuestion['options'][0]),
                      const SizedBox(width: 64.0),
                      _buildOption(currentQuestion['options'][1]),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Last two options
                      _buildOption(currentQuestion['options'][2]),
                      const SizedBox(width: 64.0),
                      _buildOption(currentQuestion['options'][3]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Submit button
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _selectedWords.length == _correctOrder.length ? _checkAnswer : null,
                child: const Text(
                  "Kirim",
                  style: TextStyle(fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
