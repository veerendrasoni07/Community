// Modern aesthetic Hackathon & Club detail screens
// Drop this file into your Flutter project and use Navigator.push

import 'package:codingera2/components/bullet_text.dart';
import 'package:codingera2/components/stat_card.dart';
import 'package:codingera2/components/user_card.dart' show UserCard;
import 'package:codingera2/models/club.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClubDetailScreen extends StatelessWidget {
  final Club club;
  const ClubDetailScreen({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(club.clubname,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(club.image, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF020617),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(club.techname,
                        style: GoogleFonts.inter(color: Colors.white)),
                  ),

                  const SizedBox(height: 18),
                  Text(club.desc,
                      style: GoogleFonts.inter(color: Colors.white70, height: 1.6)),

                  const SizedBox(height: 28),

                  Text('Leadership',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _LeaderCard(title: 'Leader', name: club.clubLeader.fullname),
                      const SizedBox(width: 12),
                      _LeaderCard(title: 'Manager', name: club.clubManager.fullname),
                    ],
                  ),

                  const SizedBox(height: 32),

                  _Section(title: 'Activities', items: club.clubActivities),
                  _Section(title: 'Rules', items: club.clubRule),

                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.group_add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () {},
                      label: Text('Join Club',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _LeaderCard extends StatelessWidget {
  final String title;
  final String name;
  const _LeaderCard({required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    color: Colors.white70, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(name,
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}



class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        // Section Card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF020617),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Colors.white.withOpacity(0.06),
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon bullet (much better than •)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Text
                    Expanded(
                      child: Text(
                        items[index],
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

