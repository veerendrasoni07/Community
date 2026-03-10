import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AdminQuiz extends ConsumerStatefulWidget {
  const AdminQuiz({super.key});

  @override
  ConsumerState<AdminQuiz> createState() => _AdminQuizState();
}

class _AdminQuizState extends ConsumerState<AdminQuiz> {
  final _formKey = GlobalKey<FormState>();
  final _quizNameController = TextEditingController();
  final _pointsController = TextEditingController(text: "10");
  final List<_QuestionInput> _questions = <_QuestionInput>[];
  final AdminController _adminController = AdminController();
  String _difficulty = "Medium";
  bool _isSaving = false;
  XFile? _bannerImage;

  @override
  void initState() {
    super.initState();
    _questions.add(_QuestionInput());
  }

  @override
  void dispose() {
    _quizNameController.dispose();
    _pointsController.dispose();
    for (final item in _questions) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBanner() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _bannerImage = image;
    });
  }

  void _addQuestion() {
    setState(() {
      _questions.add(_QuestionInput());
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length == 1) return;
    final removed = _questions.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) return;
    final points = int.tryParse(_pointsController.text.trim());
    if (points == null || points < 0) {
      showSnackBar(context, "Invalid", "Points must be a positive number", ContentType.warning);
      return;
    }

    final payload = <Map<String, dynamic>>[];
    for (final q in _questions) {
      if (!q.isValid()) {
        showSnackBar(context, "Incomplete", "Fill all options and select the correct answer", ContentType.warning);
        return;
      }
      payload.add(q.toMap());
    }

    setState(() {
      _isSaving = true;
    });
    await _adminController.uploadQuiz(
      quizName: _quizNameController.text.trim(),
      quizDifficulty: _difficulty,
      points: points,
      questions: payload,
      ref: ref,
      context: context,
      image: _bannerImage,
    );
    if (!mounted) return;
    setState(() {
      _isSaving = false;
    });
    _resetForm();
  }

  void _resetForm() {
    _quizNameController.clear();
    _pointsController.text = "10";
    for (final item in _questions) {
      item.dispose();
    }
    _questions
      ..clear()
      ..add(_QuestionInput());
    _difficulty = "Medium";
    _bannerImage = null;
    setState(() {});
  }

  Future<void> _activateQuiz(String quizId) async {
    try {
      await _adminController.activateQuiz(quizId: quizId, context: context, ref: ref);
      if (!mounted) return;
      showSnackBar(context, "Activated", "Quiz is now live", ContentType.success);
      setState(() {});
    } catch (e) {
      showSnackBar(context, "Failed", e.toString(), ContentType.failure);
    }
  }

  Future<void> _deleteQuiz(String quizId) async {
    try {
      await _adminController.deleteQuiz(quizId: quizId, context: context, ref: ref);
      if (!mounted) return;
      showSnackBar(context, "Deleted", "Quiz removed", ContentType.success);
      setState(() {});
    } catch (e) {
      showSnackBar(context, "Failed", e.toString(), ContentType.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Quiz",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formCard(),
              const SizedBox(height: 14),
              _listCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Quiz",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickBanner,
              child: Container(
                height: 135,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withValues(alpha: 0.14),
                  border: Border.all(color: Colors.white30),
                ),
                child: _bannerImage == null
                    ? Center(
                        child: Text(
                          "Tap to add quiz banner (optional)",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(File(_bannerImage!.path), fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            _inputField("Quiz Name", _quizNameController),
            _inputField("Points Per Correct Answer", _pointsController, isNumber: true),
            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              decoration: _decoration("Difficulty"),
              dropdownColor: const Color(0xFF1A3A74),
              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
              items: const ["Easy", "Medium", "Hard"]
                  .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _difficulty = value;
                });
              },
            ),
            const SizedBox(height: 14),
            ...List<Widget>.generate(_questions.length, (index) {
              return _questionCard(index);
            }),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Question"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveQuiz,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.publish),
                    label: const Text("Publish & Set Live"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionCard(int index) {
    final q = _questions[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Q${index + 1}",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _removeQuestion(index),
                icon: const Icon(Icons.delete_outline, color: Colors.white),
              ),
            ],
          ),
          _inputField("Question text", q.questionController),
          const SizedBox(height: 8),
          ...List<Widget>.generate(4, (optIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                controller: q.optionControllers[optIndex],
                validator: (value) => (value == null || value.trim().isEmpty) ? "Required" : null,
                style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
                decoration: _decoration("Option ${optIndex + 1}"),
              ),
            );
          }),
          DropdownButtonFormField<int>(
            initialValue: q.correctAnswer,
            decoration: _decoration("Correct answer"),
            dropdownColor: const Color(0xFF1A3A74),
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
            items: const [0, 1, 2, 3]
                .map((index) => DropdownMenuItem<int>(
                      value: index,
                      child: Text("Option ${index + 1}"),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                q.correctAnswer = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _listCard() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _adminController.getAllQuizzes(context: context, ref: ref),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.22),
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
                "Uploaded Quizzes",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(color: Colors.white))
              else if (snapshot.hasError)
                Text(
                  snapshot.error.toString(),
                  style: GoogleFonts.montserrat(color: Colors.white),
                )
              else ...[
                ...(snapshot.data ?? const <Map<String, dynamic>>[]).map((quiz) {
                  final quizId = quiz['_id']?.toString() ?? '';
                  final isActive = quiz['isActive'] == true;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz['quizName']?.toString() ?? '',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Difficulty: ${quiz['quizDifficulty']}  |  Questions: ${quiz['totalQuestions']}  |  Points: ${quiz['points']}",
                          style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isActive ? null : () => _activateQuiz(quizId),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                child: Text(isActive ? "Active" : "Set Active"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _deleteQuiz(quizId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade400,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _inputField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => (value == null || value.trim().isEmpty) ? "Required" : null,
      style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.10),
    );
  }
}

class _QuestionInput {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List<TextEditingController>.generate(4, (_) => TextEditingController());
  int correctAnswer = 0;

  bool isValid() {
    if (questionController.text.trim().isEmpty) return false;
    for (final option in optionControllers) {
      if (option.text.trim().isEmpty) return false;
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      "questionText": questionController.text.trim(),
      "options": optionControllers.map((option) => option.text.trim()).toList(),
      "correctAnswer": correctAnswer,
    };
  }

  void dispose() {
    questionController.dispose();
    for (final option in optionControllers) {
      option.dispose();
    }
  }
}
