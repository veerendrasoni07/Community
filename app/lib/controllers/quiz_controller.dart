import 'dart:convert';

import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/global_variable.dart';
import 'package:codingera2/models/quiz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizController {
  final AuthController _authController = AuthController();

  Future<QuizPayload> fetchActiveQuiz() async {
    final token = await _resolveToken();
    final response = await http.get(
      Uri.parse('$uri/api/quiz/active'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load quiz: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final quiz = body['quiz'] as Map<String, dynamic>?;
    if (quiz == null) {
      throw Exception('Quiz payload missing in API response');
    }
    return QuizPayload.fromMap(quiz);
  }

  Future<QuizResult> submitQuiz({
    required String quizId,
    required List<int> answers,
    String? userId,
  }) async {
    final token = await _resolveToken();
    final response = await http.post(
      Uri.parse('$uri/api/quiz-submit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'quizId': quizId,
        'answers': answers,
        if (userId != null) 'userId': userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit quiz: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Submission data missing in API response');
    }
    return QuizResult.fromMap(data);
  }

  Future<String> _resolveToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      return token;
    }

    final refreshed = await _authController.refreshTokenMethod();
    if (!refreshed) {
      throw Exception('Session expired. Please login again.');
    }

    token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Unable to resolve access token');
    }
    return token;
  }
}
