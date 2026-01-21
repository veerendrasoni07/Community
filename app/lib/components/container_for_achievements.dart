import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ContainerForAchievements extends StatelessWidget {
  final String logo;
  final String title;
  final List<Color> gradient;
  final String desc;
  final Color titlecolor;
  final Color desccolor;

  const ContainerForAchievements({
    super.key,
    required this.logo,
    required this.title,
    required this.desc,
    required this.gradient,
   required this.titlecolor, required this.desccolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              logo,
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),

          AutoSizeText(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 30,
              color: titlecolor,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            desc,
            style: TextStyle(
              fontSize: 18,
              color: desccolor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
