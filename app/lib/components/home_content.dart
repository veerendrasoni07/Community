
import 'package:codingera2/components/container_for_achievements.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});


  final List<List<Color>> gradient = [
    [Color(0xFF78B9B5),Color(0xFF0F828C),Color(0xff065084),Color(0xff320A6B)],
    [Color(0xFF0C2C55),Color(0xFF296374),Color(0xff629FAD),Color(0xffEDEDCE)],
    [Color(0xFF4E56C0),Color(0xFF9B5DE0),Color(0xffD78FEE),Color(0xffFDCFFA)],
    [Color(0xFF3C467B),Color(0xFF50589C),Color(0xff636CCB),Color(0xff6E8CFB)],
    [Color(0xFF511D43),Color(0xFF901E3E),Color(0xffDC2525),Color(0xff9BC09C)],
    [Color(0xFF123524),Color(0xFF3E7B27),Color(0xff85A947),Color(0xffEFE3C2)],
    [Color(0xFF6439FF),Color(0xFF4F75FF),Color(0xff00CCDD),Color(0xff7CF5FF)],
    [Color(0xFF37353E),Color(0xFF44444E),Color(0xff715A5A),Color(0xffD3DAD9)],
    [Color(0xFF021526),Color(0xFF03346E),Color(0xff6EACDA),Color(0xffE2E2B6)],
    [Color(0xFF321F28),Color(0xFF734046),Color(0xffA05344),Color(0xffE79E4F)],
    [Color(0xFF33313B),Color(0xFF007880),Color(0xffA05344),Color(0xff62374E)],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Why Choose Coding Era?",
            style: GoogleFonts.montserrat(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color:Colors.white.withValues(alpha: 0.8,)
            ),
          ),
        ),
        Divider(color: Colors.cyanAccent, endIndent: 50, indent: 50),
        ContainerForAchievements(
          logo: "assets/images/codinglogo.png",
          title: "Coding Excellence",
          desc:
              "Learn from expert developers and enhance your coding skills through hands on projects",
          titlecolor: Colors.white,
          gradient: gradient[0],
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        ContainerForAchievements(
          logo: "assets/images/threeperson.png",
          title: "Vibrant Community",
          gradient: gradient[1],
          desc:
              "Join a thriving community of passionate developers,share knowledge, and grow together.",
          titlecolor: Colors.white,
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        ContainerForAchievements(
          logo: "assets/images/laptop.png",
          gradient: gradient[2],
          title: "Hackathon events",
          desc:
              "Participate in exciting hackathons and turn your innovation idea into reality.",
          titlecolor: Colors.white,
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        ContainerForAchievements(
          logo: "assets/images/clubpng.png",
          title: "Club",
          gradient: gradient[3],
          desc:
              "Join or create vibrant clubs and communities to network and collaborate, and grow with like minded individuals",
          titlecolor: Colors.white,
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Our Achievement",
            style: GoogleFonts.montserrat(
            fontSize: 25,
            fontWeight: FontWeight.bold,
                color:Colors.white.withValues(alpha: 0.8,)
          ),),
        ),
        Divider(color: Colors.cyanAccent, endIndent: 50, indent: 50),
        ContainerForAchievements(
          logo: "assets/images/members.png",
          title: "500+",
          desc: "Community Members",
          gradient: gradient[4],
          titlecolor: const Color.fromARGB(255, 55, 255, 0),
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        ContainerForAchievements(
          logo: "assets/images/laptop.png",
          title: "1+",
          desc: "Hackathon Hosted",
          gradient: gradient[5],
          titlecolor: const Color.fromARGB(255, 55, 255, 0),
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        ContainerForAchievements(
          logo: "assets/images/project.png",
          title: "10+",
          desc: "Projects Completed",
          gradient: gradient[6],
          titlecolor: const Color.fromARGB(255, 55, 255, 0),
          desccolor: Colors.white,
        ),
        SizedBox(height: 20),
        ContainerForAchievements(
          logo: "assets/images/trophypng.png",
          title: "2+",
          desc: "Awards Won",
          gradient: gradient[7],
          titlecolor: const Color.fromARGB(255, 55, 255, 0),
          desccolor: Colors.white,
        ),
      ],
    );
  }
}
