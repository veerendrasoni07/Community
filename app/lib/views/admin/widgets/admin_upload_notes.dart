import 'dart:io';

import 'package:codingera2/controllers/pdf_controller.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_fonts/google_fonts.dart';


class AdminNotes extends StatefulWidget {
  const AdminNotes({super.key});

  @override
  State<AdminNotes> createState() => _AdminQuizState();
}

class _AdminQuizState extends State<AdminNotes> {
  final PdfController controller = PdfController();

  String? subject;
  String? semester;
  String? chapter;
  TextEditingController chapterController = TextEditingController();
  String? noteType;
  PlatformFile? pickedPdf;
  bool isOther = false;

  final semesters = {
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
    "Eight Semester":[
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

  Future<void> pickPdf()async{
    try{
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
      if(filePickerResult != null){
        setState(() {
          pickedPdf = filePickerResult.files.first;
        });
      }
      if (pickedPdf == null || pickedPdf!.path == null) {
        showSnackBar(context, "PDF Warning", "Please select a valid PDF", ContentType.failure);
        return;
      }
    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> savePdf()async{
    try{
      showDialog(context: context,barrierDismissible: false, builder: (context){
        return Center(child: CircularProgressIndicator(color: Colors.white,),);
      });
      await controller.uploadPdfNotes(subject: subject!,noteType:noteType! ,semester: semester!, chapter: chapterController.text.trim(), pdf: pickedPdf!.path!, context: context);
      Navigator.pop(context);
      Navigator.pop(context);
    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Upload Notes"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: pickPdf,
                    child: pickedPdf == null ? Container(
                      height: 180,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                      child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.squareFontAwesomeStroke,color: Colors.white,size: 40,),
                            Text(pickedPdf!=null ? pickedPdf!.name : "Select PDF",style: TextStyle(color: Colors.white,fontSize: 16)),
                          ],
                        ),
                      ),
                    ) : Container(
                      height: 180,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      child:  Center(
                        child: Text(pickedPdf!=null ? pickedPdf!.name : "Select PDF",style: TextStyle(color: Colors.white,fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  _dropDownOptions(semesters.keys.toList(), (value){
                    setState(() {
                      semester = value;
                      subject = null;
                      chapterController.clear();
                      noteType = null;
                    });
                  }, "Select Semester", "Semester"),
                  semester != null ? _dropDownOptions(semesters[semester]!, (value){
                    setState(() {
                      subject = value;
                        chapterController.clear();
                        noteType = null;
                    });
                  }, "Select Subject", "Subject") : SizedBox(),
                  subject!=null ? input("Chapter", chapterController, "ex: Water") : SizedBox(),
                  chapterController.text.isNotEmpty ? _dropDownOptions(['Detailed Notes', 'Short Notes', 'Important Questions'], (value) {
                    setState(() {
                      noteType=value!;
                    });
                  }, 'Select Note Type', 'Note Type') : SizedBox(),

                  Center(
                    child: ElevatedButton(
                        onPressed: ()async{
                          if(!_formKey.currentState!.validate() || semester==null || subject==null || chapterController.text.isEmpty || noteType==null || pickedPdf==null){
                            showSnackBar(context, "Warning", "Please fill all the fields", ContentType.warning);
                          }else{
                            await savePdf();
                          }
                        },
                        child: Text("Submit")
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      )
    );
  }


  Widget _dropDownOptions(List<String> options,Function(String?) onChanged,String text,String heading) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          DropdownButtonFormField(
            initialValue:options[0],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            hint: Text(text,style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),overflow: TextOverflow.ellipsis),
            isExpanded: true,
            items: options.map((m) =>
                DropdownMenuItem(
                    value: m,
                    child: Text(m)
                )).toList(),
            onChanged: onChanged,
            validator: (v) => v == null ? "Required" : null,
          ),
        ],
      ),
    );
  }
  Widget input(String label, TextEditingController c,
      String hintText,
      {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 10,),
          TextFormField(
            controller: c,
            keyboardType: type,
            validator: (v) => v!.isEmpty ? "Required" : null,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
