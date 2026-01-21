import 'package:codingera2/models/hackathon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/info_tile.dart';


class HackathonDetailScreen extends StatelessWidget {
  final Hackathon hackathon;
  const HackathonDetailScreen({super.key, required this.hackathon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                hackathon.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(hackathon.image, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GlassStats(hackathon: hackathon),

                  const SizedBox(height: 28),

                  Text('About the Hackathon',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(hackathon.description,
                      style: GoogleFonts.inter(
                          color: Colors.white70, height: 1.6)),

                  const SizedBox(height: 32),

                  InfoTile(icon: Icons.calendar_today, label: 'Date', value: hackathon.eventdate.toString().split("T")[0]),
                  InfoTile(icon: Icons.access_time, label: 'Time', value: hackathon.eventTime),
                  InfoTile(icon: Icons.location_on, label: 'Venue', value: hackathon.venue),

                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Register Now',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
class _GlassStats extends StatelessWidget {
  final Hackathon hackathon;
  const _GlassStats({required this.hackathon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GlassStatItem(
            icon: Icons.emoji_events,
            label: 'Prize',
            value: '₹${hackathon.prize}',
          ),
          _GlassStatItem(
            icon: Icons.groups,
            label: 'Teams',
            value: '${hackathon.totalTeam}',
          ),
          _GlassStatItem(
            icon: Icons.person,
            label: 'Team Size',
            value: '${hackathon.teamsize}',
          ),
          _GlassStatItem(
            icon: Icons.trending_up,
            label: 'Level',
            value: hackathon.level,
          ),
        ],
      ),
    );
  }
}
class _GlassStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _GlassStatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6366F1).withOpacity(0.18),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,

          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}

