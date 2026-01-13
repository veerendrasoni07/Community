import 'dart:io';

import 'package:codingera2/controllers/pdf_controller.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AdminNotes extends StatefulWidget {
  const AdminNotes({super.key});

  @override
  State<AdminNotes> createState() => _AdminQuizState();
}

class _AdminQuizState extends State<AdminNotes> {
  final PdfController controller = PdfController();

  TextEditingController subjectController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController noteTypeController = TextEditingController();
  PlatformFile? pickedPdf;

  Future<void> pickPdf()async{
    try{
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
      if(filePickerResult != null){
        setState(() {
          pickedPdf = filePickerResult.files.first;
        });
      }
      if (pickedPdf == null || pickedPdf!.path == null) {
        showSnackBar(context, "Select a valid PDF");
        return;
      }
    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }
  }

  Future<void> savePdf()async{
    try{
      await controller.uploadPdfNotes(subject: subjectController.text.trim(),noteType:noteTypeController.text.trim() ,semester: semesterController.text.trim(), chapter: chapterController.text.trim(), pdf: pickedPdf!.path!, context: context);
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
                input("Semester", semesterController, "ex: 1st Semester"),
                input("Subject", subjectController,"ex: Chemistry"),
                input("Chapter", chapterController, "ex: Water"),
                input("Note Type", noteTypeController, 'Detailed Notes, Short Notes, Important Questions'),
                ElevatedButton(
                    onPressed: ()async{
                      await savePdf();
                    },
                    child: Text("Submit")
                )

              ],
            ),
          ),
        ),
      )
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
