import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tebak_gambar/models/questionmodel.dart';
import 'package:tebak_gambar/utils/quizprogressmanager.dart';

class SusunKalimat extends StatefulWidget {
  final String currentlevel;
  final String levelMark;
  final Function(int) onProgressUpdate; // Add this line
  final String difficulty;

  const SusunKalimat({super.key, required this.currentlevel, required this.onProgressUpdate, required this.difficulty, required this.levelMark});

  @override
  _SusunKalimatState createState() => _SusunKalimatState();
}

class _SusunKalimatState extends State<SusunKalimat> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  List<String> _selectedWords = [];
  List<String> _correctOrder = [];
  bool _showHint = false;
  int _answeredCount = 0;
  bool _isLoading = true;
  Question? currentQuestion;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      final data = await rootBundle.loadString('assets/utils/susunkalimat_quiz.json');
      final List<dynamic> jsonData = json.decode(data);

      // Convert to Question objects and filter by levelMark
      _questions = jsonData
          .map((json) => Question.fromJson(json))
          .where((question) => question.levelMark == widget.levelMark && question.difficulty == widget.difficulty)
          .toList();

      setState(() {
        _isLoading = false;
        if (_questions.isNotEmpty) {
          currentQuestion = _questions[_currentQuestionIndex];
          _correctOrder = currentQuestion!.correctOrder ?? [];
        } else {
          currentQuestion = null;
          _correctOrder = [];
        }
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        _isLoading = false;
        currentQuestion = null;
        _correctOrder = [];
      });
    }
  }

  void _updateCurrentQuestion() {
    if (_currentQuestionIndex < _questions.length) {
      currentQuestion = _questions[_currentQuestionIndex];
      _correctOrder = currentQuestion!.correctOrder ?? [];
      _selectedWords = [];
      _showHint = false;
    }
  }

  Future<void> _checkAnswer() async {
    if (currentQuestion == null) return;

    bool isCorrect = _selectedWords.join(' ') == _correctOrder.join(' ');

    // Save progress with levelMark
    await QuizProgressManager.saveAnsweredQuestion('susun_kalimat', widget.levelMark, widget.difficulty);

    setState(() {
      _answeredCount++;
    });

    widget.onProgressUpdate(_answeredCount);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();

          if (_currentQuestionIndex < _questions.length - 1) {
            setState(() {
              _currentQuestionIndex++;
              _updateCurrentQuestion();
            });
          } else {
            // All questions completed
            // Save completion state
            QuizProgressManager.saveLevelCompletion('susun_kalimat', widget.levelMark, widget.difficulty);
            // Navigate back to quiz levelling
            Navigator.of(context).pop(); // Pop the current screen
            Navigator.of(context).pop(); // Pop the quiz screen
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
                isCorrect ? "Susunan benar!" : "Susunan salah.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0, fontFamily: 'Raleway'),
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 8.0),
                Text(
                  "Jawaban yang benar:\n${_correctOrder.join(' ')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Raleway',
                  ),
                ),
              ],
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
          fontFamily: 'Raleway',
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
    _correctOrder = List<String>.from(currentQuestion.correctOrder as Iterable);

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
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              // Hint Button
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.lightbulb_circle_outlined, size: 48.0, color: Colors.grey[700]),
                      onPressed: () {
                        if (currentQuestion.answerClue != null) {
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
                                      currentQuestion.answerClue ?? 'No hint available',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Raleway',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Question Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 4.0,
                  color: Colors.grey[350],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentQuestion.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Selected Words Area
              Container(
                constraints: const BoxConstraints(minHeight: 80.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: _selectedWords.asMap().entries.map((entry) {
                    int index = entry.key;
                    String word = entry.value;

                    return Chip(
                      backgroundColor: Colors.blue[100],
                      label: Text(word,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Raleway',
                          )),
                      deleteIcon: const Icon(Icons.close, size: 20),
                      onDeleted: () => _removeWord(index),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24.0),

              // Word Options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final options = currentQuestion.options as List<dynamic>? ?? [];
                      final int optionsCount = options.length;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            spacing: constraints.maxWidth * 0.15, // Responsive spacing
                            runSpacing: 25.0,
                            alignment: WrapAlignment.center,
                            children: List.generate(optionsCount, (index) {
                              final bool isWordSelected = _selectedWords.contains(options[index]);
                              return Opacity(
                                opacity: isWordSelected ? 0.5 : 1.0,
                                child: GestureDetector(
                                  onTap: isWordSelected ? null : () => _addWord(options[index].toString()),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: isWordSelected ? Colors.grey[300] : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      options[index].toString(),
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: isWordSelected ? Colors.grey[600] : Colors.black,
                                        fontFamily: 'Raleway',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Submit Button
              Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2,
                    ),
                    onPressed: (_selectedWords.length == _correctOrder.length) ? _checkAnswer : null,
                    child: Text(
                      "Kirim",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: (_selectedWords.length == _correctOrder.length) ? Colors.white : Colors.grey[400],
                        fontFamily: 'Raleway',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
