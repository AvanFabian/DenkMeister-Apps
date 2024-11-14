
class Question {
  final String type;
  final String question;
  final List<String> options;
  final String? correctAnswer; // untuk tipe soal yang membutuhkan jawaban benar
  final List<String>? correctOrder; // untuk tipe "SUSUN_KALIMAT"

  Question({
    required this.type,
    required this.question,
    required this.options,
    this.correctAnswer,
    this.correctOrder,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      correctOrder: json['correctOrder'] != null
          ? List<String>.from(json['correctOrder'])
          : null,
    );
  }
}