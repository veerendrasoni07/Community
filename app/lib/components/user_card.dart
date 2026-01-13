import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  final String title;
  final String name;
  const UserCard({required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(title,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold,color: Colors.white)),
            const SizedBox(height: 6),
            Text(name,style: GoogleFonts.lato(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}