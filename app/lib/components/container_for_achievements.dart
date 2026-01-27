import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ContainerForAchievements extends StatefulWidget {
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
  State<ContainerForAchievements> createState() => _ContainerForAchievementsState();
}

class _ContainerForAchievementsState extends State<ContainerForAchievements> with SingleTickerProviderStateMixin{
  
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:widget.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.gradient.last.withOpacity(0.35),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.logo,
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),

          AutoSizeText(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 30,
              color: widget.titlecolor,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            widget.desc,
            style: TextStyle(
              fontSize: 18,
              color: widget.desccolor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
