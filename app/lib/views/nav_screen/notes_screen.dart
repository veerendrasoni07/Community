import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {


  String? selectedSemester;
  String? selectedSubject;
  String? noteType;

  List<String> sem = [
    "First Semester",
    "Second Semester",
    "Third Semester",
    "Fourth Semester",
    "Fifth Semester",
    "Sixth Semester",
    "Seventh Semester",
    "Eighth Semester",
  ];

  Map<String, List<String>> subjects = {
    "First Semester": [
      "Mathematics I",
      "Engineering Chemistry",
      "Engineering Graphics",
      "BEEE",
    ],
    "Second Semester": [
      "Mathematics II",
      "Engineering Physics",
      "BME",
      "Basic Civil Engineering And Engineering Mechanics",
      "Basic Computer Engineering"
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _dropDownMembers(sem, (value){
              setState(() {
                selectedSemester = value;
              });
            }, "Semester", "Select Semester"),
            (selectedSemester!=null && subjects[selectedSemester] != null) ? _dropDownMembers(subjects[selectedSemester]!, (value){
              setState(() {
                selectedSubject = value;
              });
            }, "Subject", "Select Subject") : SizedBox(),
        
             _dropDownMembers([
               "Detailed Notes",
               "Short Notes",
               "Important Questions"
             ], (value){
              setState(() {
                noteType = value;
              });
            }, "Subject", "Select Subject")
          ],
        ),
      )
    );
  }
  Widget _dropDownMembers(List<String> options,Function(String) onChanged,String text,String heading){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          DropdownButtonFormField(
            hint: Text(text),
            items: options.map((m)=>DropdownMenuItem(
                value: m,
                child: Text(m)
            )).toList(),
            onChanged: (value){
              onChanged(value!);
            },
            validator: (v) => v == null ? "Required" : null,
          ),
        ],
      ),
    );

  }
}
