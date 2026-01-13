import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: GoogleFonts.inter(color: Colors.white60)),
          Expanded(child: Text(value, style: GoogleFonts.inter(color: Colors.white))),
        ],
      ),
    );
  }
}