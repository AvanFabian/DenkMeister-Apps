import 'package:shared_preferences/shared_preferences.dart';

class QuizProgressManager {
  static const String answeredQuestionsTebakGambarKey = 'answered_questions_tebak_gambar';
  static const String answeredQuestionsCocokKataKey = 'answered_questions_cocok_kata';
  static const String answeredQuestionsKalimatRumpangKey = 'answered_questions_kalimat_rumpang';
  static const String answeredQuestionsSusunKalimatKey = 'answered_questions_susun_kalimat';

  // General method to get answered questions by key
  static Future<int> getAnsweredQuestions(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0; // Default to 0 if no value saved
  }

  // General method to save answered questions by key
  static Future<void> saveAnsweredQuestions(String key, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, count);
  }

  // General method to reset answered questions by key
  static Future<void> resetAnsweredQuestions(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
