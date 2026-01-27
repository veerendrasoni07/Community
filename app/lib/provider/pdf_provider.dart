import 'package:codingera2/controllers/pdf_controller.dart';
import 'package:codingera2/models/pdf.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PdfProvider extends StateNotifier<List<Pdf>>{
  PdfProvider():super([]);


  Future<List<Pdf>> getPdf({
    required String subject,
    required String semester,
    required String noteType,
    required BuildContext context,
})async{
    final pdfs = await PdfController().getAllPdf(subject: subject, semester: semester, noteType: noteType, context: context);
    state = pdfs;
    return state;
  }

}
final pdfProvider = StateNotifierProvider<PdfProvider,List<Pdf>>((ref)=> PdfProvider());