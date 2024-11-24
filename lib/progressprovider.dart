import 'package:flutter/material.dart';

class ProgressProvider with ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  // Update the progress based on the total number of questions and current question
  void updateProgress(int currentQuestionIndex, int totalQuestions) {
    _progress = currentQuestionIndex / totalQuestions;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
