class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id']?.toString() ?? '',
      questionText: map['questionText']?.toString() ?? '',
      options: List<String>.from(map['options'] ?? const <String>[]),
    );
  }
}

class QuizPayload {
  final String id;
  final String quizName;
  final String quizBanner;
  final String quizDifficulty;
  final int points;
  final int totalQuestions;
  final List<QuizQuestion> questions;

  QuizPayload({
    required this.id,
    required this.quizName,
    required this.quizBanner,
    required this.quizDifficulty,
    required this.points,
    required this.totalQuestions,
    required this.questions,
  });

  factory QuizPayload.fromMap(Map<String, dynamic> map) {
    return QuizPayload(
      id: map['_id']?.toString() ?? '',
      quizName: map['quizName']?.toString() ?? '',
      quizBanner: map['quizBanner']?.toString() ?? '',
      quizDifficulty: map['quizDifficulty']?.toString() ?? 'Medium',
      points: int.tryParse(map['points']?.toString() ?? '') ?? 0,
      totalQuestions: int.tryParse(map['totalQuestions']?.toString() ?? '') ?? 0,
      questions: (map['questions'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) => QuizQuestion.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizResult {
  final int correctCount;
  final int totalQuestions;
  final int score;
  final double accuracy;

  QuizResult({
    required this.correctCount,
    required this.totalQuestions,
    required this.score,
    required this.accuracy,
  });

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      correctCount: int.tryParse(map['correctCount']?.toString() ?? '') ?? 0,
      totalQuestions: int.tryParse(map['totalQuestions']?.toString() ?? '') ?? 0,
      score: int.tryParse(map['score']?.toString() ?? '') ?? 0,
      accuracy: double.tryParse(map['accuracy']?.toString() ?? '') ?? 0,
    );
  }
}
