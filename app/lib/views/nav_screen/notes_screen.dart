import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codingera2/components/inside_app_button.dart';
import 'package:codingera2/provider/pdf_provider.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:codingera2/views/details/notes_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {

  bool isFetching = false;
  String? selectedSemester;
  String? selectedSubject;
  String? noteType;



  Map<String, List<String>> subjects = {
    "First Semester": [
      "Chemistry",
      "Physics",
      "Mathematics-I",
      "Engineering Graphics",
      "BEEE"
    ],
    "Second Semester":[
      "Engineering Physics",
      "Mathematics-II",
      "Basic Mechanical Engineering",
      "Basic Civil Engineering & Mechanics",
      "Basic Computer Engineering"
    ],
    "Third Semester":[
      "Energy & Environmental Engineering",
      "Discrete Structure",
      "Data Structure",
      "Digital Systems",
      "Object Oriented Programming & Methodology"
    ],
    "Fourth Semester":[
      "Mathematics-III",
      "Analysis Design of Algorithm",
      "Software Engineering",
      "Operating Systems",
      "Programming Practices "
    ],
    "Fifth Semester":[
      "Theory of Computation",
      "Database Management Systems",
      "Data Analytics",
      "Pattern Recognition",
      "Cyber Security",
      "Internet and Web Technology",
      "Object Oriented Programming",
      "Introduction to Database Management Systems",
    ],
    "Sixth Semester":[
      "Machine Learning",
      "Computer Networks",
      "Advanced Computer Architecture (ACA)",
      "Computer Graphics & Visualization",
      "Compiler Design",
      "Knowledge Management",
      "Project Management",
      "Rural Technology & Community Development",
      "Data Analytics Lab",
      "Skill Development Lab"
    ],
    "Seventh Semester":[
      "Software Architectures",
      "Computational Intelligence",
      "Deep & Reinforcement Learning",
      "Wireless & Mobile Computing",
      "Big Data",
      "Cryptography & Information Security",
      "Data Mining and Warehousing",
      "Agile Software Development",
      " Disaster Management",
    ],
    "Eighth Semester":[
      "Internet of Things",
      "Block Chain Technologies",
      "Cloud Computing",
      "High Performance computing",
      "Object Oriented Software Engineering",
      "Image Processing and Computer Vision",
      "Game Theory with Engineering applications",
      "Open Elective – CS803 (C) Internet of Things",
      "Managing Innovation and Entrepreneurship#"
    ]

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title:  Text("Notes",style: GoogleFonts.montserrat(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          _dropDownMembers(subjects.keys.toList(), (value){
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
          }, "Subject", "Select Note Type"),
          appButton(onPressed: isFetching ? null : ()async{

            if( selectedSubject != null && selectedSemester != null && noteType != null ){
              setState(() {
                isFetching = true;
              });
              showDialog(context: context,barrierDismissible: false, builder: (context){
                return Center(child: CircularProgressIndicator(color: Colors.white,),);
              });
              final pdfs = await ref.read(pdfProvider.notifier).getPdf(subject: selectedSubject!, semester: selectedSemester!, noteType: noteType!, context: context);
              Navigator.pop(context);
              if(pdfs.isNotEmpty){
                setState(() {
                  isFetching = false;
                });
                Get.to(
                        ()=> NotesPdfScreen(),
                  transition: Transition.cupertinoDialog,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500)
                );
              }
              else{
                setState(() {
                  isFetching = false;
                });
                showSnackBar(context, "Unfortunately!" ,"Sorry Notes For This Subject Is Not Available!",ContentType.help);
              }
            }else{
              showSnackBar(context, "Unfortunately!" ,"Please Select All The Fields!",ContentType.warning);
            }


          }, text: "Get", context: context),

        ],
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
          DropdownButtonFormField(
            isExpanded: true,
            initialValue: options[0] ,
            hint: Text(text,style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),overflow: TextOverflow.ellipsis,),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            items: options.map((m)=>DropdownMenuItem(
                value: m,
                child: Text(m,style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),overflow: TextOverflow.ellipsis,)
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
