
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  const StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
