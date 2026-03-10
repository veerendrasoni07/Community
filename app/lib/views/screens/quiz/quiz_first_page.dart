import 'package:flutter/material.dart';
import 'package:codingera2/controllers/quiz_controller.dart';
import 'package:codingera2/models/quiz.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizFirstPage extends ConsumerStatefulWidget {
  const QuizFirstPage({super.key});

  @override
  ConsumerState<QuizFirstPage> createState() => _QuizFirstPageState();
}

class _QuizFirstPageState extends ConsumerState<QuizFirstPage> {
  final QuizController _quizController = QuizController();
  QuizPayload? _quiz;
  QuizResult? _result;
  bool _isLoading = true;
  bool _isSubmitting = false;
  int _currentQuestionIndex = 0;
  List<int> _answers = <int>[];

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final quiz = await _quizController.fetchActiveQuiz();
      setState(() {
        _quiz = quiz;
        _answers = List<int>.filled(quiz.questions.length, -1);
      });
    } catch (error) {
      if (mounted) {
        showSnackBar(
          context,
          "Quiz Error",
          error.toString(),
          ContentType.failure,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = optionIndex;
    });
  }

  Future<void> _submitQuiz() async {
    if (_quiz == null || _isSubmitting) {
      return;
    }

    final unansweredCount = _answers.where((answer) => answer == -1).length;
    if (unansweredCount > 0) {
      showSnackBar(
        context,
        "Incomplete",
        "Please answer all questions before submitting.",
        ContentType.warning,
      );
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });
      final user = ref.read(userProvider);
      final result = await _quizController.submitQuiz(
        quizId: _quiz!.id,
        answers: _answers,
        userId: user?.id,
      );

      if (!mounted) return;
      setState(() {
        _result = result;
      });
      _showResultSheet(result);
    } catch (error) {
      if (mounted) {
        showSnackBar(
          context,
          "Submit Failed",
          error.toString(),
          ContentType.failure,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showResultSheet(QuizResult result) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Quiz Completed",
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${result.correctCount}/${result.totalQuestions} Correct",
                  style: GoogleFonts.montserrat(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Score: ${result.score}  |  Accuracy: ${result.accuracy.toStringAsFixed(1)}%",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Review",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(this.context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Done",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextQuestion() {
    if (_quiz == null) return;
    if (_currentQuestionIndex >= _quiz!.questions.length - 1) return;
    setState(() {
      _currentQuestionIndex += 1;
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex == 0) return;
    setState(() {
      _currentQuestionIndex -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quiz;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Daily Quiz",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : quiz == null
              ? Center(
                  child: Text(
                    "Quiz not available right now",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : _buildQuizContent(quiz),
    );
  }

  Widget _buildQuizContent(QuizPayload quiz) {
    if (quiz.questions.isEmpty) {
      return Center(
        child: Text(
          "No questions available",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final question = quiz.questions[_currentQuestionIndex];
    final answeredCount = _answers.where((answer) => answer != -1).length;
    final progress = quiz.questions.isEmpty
        ? 0.0
        : (_currentQuestionIndex + 1) / quiz.questions.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.28),
                    Colors.white.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.quizName,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Difficulty: ${quiz.quizDifficulty}   |   Answered: $answeredCount/${quiz.totalQuestions}",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: LinearProgressIndicator(
                      minHeight: 9,
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.20),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.98),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question ${_currentQuestionIndex + 1}",
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question.questionText,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      height: 1.35,
                      color: const Color(0xFF0A1E42),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List<Widget>.generate(question.options.length, (index) {
                    final isSelected = _answers[_currentQuestionIndex] == index;
                    return GestureDetector(
                      onTap: () => _selectOption(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 12),
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.15)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.blueGrey.withValues(alpha: 0.20),
                            width: isSelected ? 1.7 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.blueGrey.withValues(alpha: 0.14),
                              ),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: GoogleFonts.montserrat(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF244A8A),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF142A53),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentQuestionIndex == 0 ? null : _previousQuestion,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    label: Text(
                      "Prev",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.65)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentQuestionIndex == quiz.questions.length - 1
                        ? _submitQuiz
                        : _nextQuestion,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _currentQuestionIndex == quiz.questions.length - 1
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                    label: Text(
                      _currentQuestionIndex == quiz.questions.length - 1
                          ? "Submit"
                          : "Next",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Text(
                "Last Score: ${_result!.correctCount}/${_result!.totalQuestions}",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
