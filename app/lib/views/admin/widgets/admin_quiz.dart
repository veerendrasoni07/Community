import 'package:flutter/material.dart';

class AdminQuiz extends StatefulWidget {
  const AdminQuiz({super.key});

  @override
  State<AdminQuiz> createState() => _AdminQuizState();
}

class _AdminQuizState extends State<AdminQuiz> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Admin Quiz"),
      ),
    );
  }
}
