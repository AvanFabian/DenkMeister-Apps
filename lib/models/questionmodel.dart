
class Question {
  final int level;
  final String question;
  final List<String> options;
  final String? correctAnswer; // untuk tipe soal yang membutuhkan jawaban benar
  final List<String>? correctOrder; // untuk tipe "SUSUN_KALIMAT"
  final String? answerClue; // untuk tipe soal yang membutuhkan jawaban benar

  Question({
    required this.level,
    required this.question,
    required this.options,
    this.correctAnswer,
    this.correctOrder,
    this.answerClue,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      level: json['level'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      correctOrder: json['correctOrder'] != null
          ? List<String>.from(json['correctOrder'])
          : null,
      answerClue: json['answerClue'],
    );
  }
}