

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appButton({required void Function()? onPressed, required String text,required BuildContext context}){
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.65, 50),
        maximumSize: Size(MediaQuery.of(context).size.width * 0.65, 50),
        fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      child: Text(text,style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.deepPurpleAccent)));
}