import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const InfoContainer({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color:Colors.blueAccent.shade700,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon,size: 30,color: Colors.white,),
            const SizedBox(width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white70,),),
                Text(subtitle.isEmpty ? "---" : subtitle,style: TextStyle(fontSize: 16,color: Colors.white70),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
