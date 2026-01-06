import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final TextEditingController? controller;
  final String? hinttext;
  final String? Function(String?)? validator;
  const TextFields({super.key,required this.controller,required this.hinttext,required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        hintText: hinttext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
      ),
      cursorColor: Colors.black87,
      style: TextStyle(
          color: Colors.black87,

          fontSize: 16,
      ),
    );
  }
}
