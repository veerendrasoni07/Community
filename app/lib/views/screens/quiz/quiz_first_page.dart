import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizFirstPage extends StatelessWidget {
  const QuizFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(FontAwesomeIcons.arrowLeft,color: Colors.white,)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Coming Soon!",style: GoogleFonts.montserrat(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),
          )
        ],
      ),
    );
  }
}
