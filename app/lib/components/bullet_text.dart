import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BulletText extends StatelessWidget {
  final String text;
  const BulletText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text('• ',style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
          Expanded(child: Text(text,style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),)),
        ],
      ),
    );
  }
}