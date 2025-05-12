// Modified QuizProgressManager
import 'package:shared_preferences/shared_preferences.dart';

class QuizProgressManager {
  static const String answeredQuestionsTebakGambarKey = 'answered_questions_tebak_gambar';
  static const String answeredQuestionsCocokKataKey = 'answered_questions_cocok_kata';
  static const String answeredQuestionsKalimatRumpangKey = 'answered_questions_kalimat_rumpang';
  static const String answeredQuestionsSusunKalimatKey = 'answered_questions_susun_kalimat';

  // Save answered question with level and difficulty
  static Future<void> saveAnsweredQuestion(String quizType, String level, String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${quizType}_${level}_$difficulty';
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);

    // Also update total count
    final totalKey = 'total_$quizType';
    final totalCount = prefs.getInt(totalKey) ?? 0;
    await prefs.setInt(totalKey, totalCount + 1);
  }

  // Save level completion state
  static Future<void> saveLevelCompletion(String quizType, String level, String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${quizType}_completed_${level}_$difficulty';
    await prefs.setBool(key, true);
  }

  // Check if level is completed
  static Future<bool> isLevelCompleted(String quizType, String level, String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${quizType}_completed_${level}_$difficulty';
    return prefs.getBool(key) ?? false;
  }

  // Get answered questions count for a specific level and difficulty
  static Future<int> getAnsweredQuestionsForLevel(String quizType, String level, String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${quizType}_${level}_$difficulty';
    return prefs.getInt(key) ?? 0;
  }

  // Get total answered questions for a quiz type
  static Future<int> getTotalAnsweredQuestions(String quizType) async {
    final prefs = await SharedPreferences.getInstance();
    final totalKey = 'total_$quizType';
    return prefs.getInt(totalKey) ?? 0;
  }

  // Reset progress for a specific quiz type
  static Future<void> resetProgress(String quizType) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(quizType));
    for (var key in keys) {
      await prefs.remove(key);
    }
  }
}
