import 'package:codingera2/controllers/pdf_controller.dart';
import 'package:codingera2/models/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PdfProvider extends StateNotifier<Pdf?>{
  PdfProvider():super(null);


  Future<void> setPdf({
    required String subject,
    required String semester,
    required String noteType,
    required BuildContext context,
})async{
    await PdfController().getAllPdf(subject: subject, semester: semester, noteType: noteType, context: context);
  }

}
final pdfProvider = StateNotifierProvider<PdfProvider,Pdf?>((ref)=> PdfProvider());