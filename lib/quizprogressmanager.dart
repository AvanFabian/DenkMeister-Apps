import 'package:shared_preferences/shared_preferences.dart';

class QuizProgressManager {
  static const String _answeredQuestionsKey = 'answered_questions';

  static Future<int> getAnsweredQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_answeredQuestionsKey) ?? 0; // Default to 0 if no value saved
  }

  static Future<void> saveAnsweredQuestions(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_answeredQuestionsKey, count);
  }

  static Future<void> resetAnsweredQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_answeredQuestionsKey);
  }
}