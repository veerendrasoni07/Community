import 'dart:convert';
import 'dart:io';

import 'package:codingera2/global_variable.dart';
import 'package:codingera2/models/pdf.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class PdfController {



  Future<void> uploadPdfNotes({
    required String subject,
    required String semester,
    required String chapter,
    required String pdf,
    required String noteType,
    required BuildContext context,
})async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

      final request = http.MultipartRequest(
          "POST", Uri.parse('$uri/api/upload-pdf'));
      request.fields['subject'] = subject;
      request.fields['semester'] = semester;
      request.fields['chapterName'] = chapter;
      request.fields['noteType'] = noteType;
      request.files.add(await http.MultipartFile.fromPath("pdf", pdf));
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      final response = await request.send();
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      if (response.statusCode == 200) {
        showSnackBar(context, "Pdf uploaded successfully");
      } else {
        print(response.statusCode);
        showSnackBar(context, "Something went wrong");
      }
    } catch (e) {
      print(e);
      throw Exception("Something went wrong");
    }
  }


  Future<List<Pdf>> getAllPdf({
    required String subject,
    required String semester,
    required String noteType,
    required BuildContext context,
})async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-pdf?subject=${subject}&semester=${semester}&noteType=${noteType}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
      );
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        print(data);
        final List<Pdf> pdfs = data.map((p)=>Pdf.fromMap(p)).toList();
        return pdfs;
      }else{
        print(response.body);
        throw Exception("Something went wrong");
      }
    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }
  }


}