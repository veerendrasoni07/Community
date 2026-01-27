import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codingera2/provider/pdf_provider.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:codingera2/views/details/notes_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          }, "Subject", "Select Subject"),
          ElevatedButton(
              onPressed: isFetching ? null : ()async{

                if( selectedSubject != null ){
                  setState(() {
                    isFetching = true;
                  });
                  final pdfs = await ref.read(pdfProvider.notifier).getPdf(subject: selectedSubject!, semester: selectedSemester!, noteType: noteType!, context: context);
                  if(pdfs.isNotEmpty){
                    setState(() {
                      isFetching = false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NotesPdfScreen()));
                  }
                  else{
                    setState(() {
                      isFetching = false;
                    });
                    showSnackBar(context, "Unfortunately!" ,"Sorry Notes For This Subject Is Not Available!",ContentType.help);
                  }
                }else{
                  showSnackBar(context, "Unfortunately!" ,"Sorry! Notes For This Semester Is Not Available",ContentType.help);
                }


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(12),
              ),
              child: isFetching ? Center(child: CircularProgressIndicator()) : Text("Get",style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),))
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
