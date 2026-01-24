import 'package:codingera2/models/club.dart';
import 'package:codingera2/models/user.dart';
import 'package:codingera2/views/details/club_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernClubTile extends StatelessWidget {
  final Club club;
  final int index;

  ModernClubTile({
    super.key,
    required this.club,
    required this.index,
  });

  final List<List<Color>> gradientPalette = [
    [Colors.deepPurple, Colors.pink],
    [Colors.indigo, Colors.blue],
    [Colors.teal, Colors.green],
    [Colors.orange, Colors.deepOrange],
    [Colors.purple, Colors.deepPurple],
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = gradientPalette[index % gradientPalette.length];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tech Chip
                  Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      club.techname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Club name
                  Text(
                    club.clubname,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Short description
                  Text(
                    club.desc,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Leadership section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _leaderInfo(Icons.person, "Leader", club.clubLeader.fullname),
                  _leaderInfo(Icons.manage_accounts, "Manager", club.clubManager.fullname),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // CTA Button
            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ClubDetailScreen(club: club))),
              child: Center(
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(colors: gradient),
                  ),
                  child: const Center(
                    child: Text(
                      "Join Club",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _leaderInfo(IconData icon, String label, String name) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11)),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
