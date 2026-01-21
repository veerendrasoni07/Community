
import 'package:codingera2/components/container_for_achievements.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});


  final List<List<Color>> gradient = [
    [Colors.blue.shade900, Colors.cyanAccent],
    [Colors.teal.shade900, Colors.tealAccent],
    [Colors.blue.shade900, Colors.blueAccent.shade100],
    [Colors.white10,Colors.white],
    [Colors.deepPurple.shade900, Colors.deepPurpleAccent.shade100],
    [Colors.green.shade900, Colors.greenAccent],
    [Colors.brown.shade900, Colors.brown.shade100],
    [Colors.deepOrange, Colors.orangeAccent],
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
              color: Colors.white,
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
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        ),
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
