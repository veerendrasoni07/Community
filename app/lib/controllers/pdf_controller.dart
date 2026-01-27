import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codingera2/global_variable.dart';
import 'package:codingera2/models/pdf.dart';
import 'package:codingera2/provider/isdownload_provider.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../provider/download_progress_provider.dart';
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

      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

      final request = http.MultipartRequest(
          "POST", Uri.parse('$uri/api/upload-note-pdf'));
      request.fields['subject'] = subject;
      request.fields['semester'] = semester;
      request.fields['chapterName'] = chapter;
      request.fields['noteType'] = noteType;
      request.files.add(await http.MultipartFile.fromPath("pdf", pdf));
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      final response = await request.send();
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      if (response.statusCode == 200) {
        showSnackBar(context, "Success","Pdf uploaded successfully",ContentType.success);
      } else {
        print(response.statusCode);
        showSnackBar(context, "Error!","Something went wrong",ContentType.failure);
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

  Future<void> downloadPdf({
    required WidgetRef ref,
    required BuildContext context,
    required String pdfUrl,
    required String fileName,
  }) async {
    try {
      debugPrint("PDF URL: $pdfUrl");

      ref.read(isDownloadingProvider.notifier).state = true;
      ref.read(downloadProgressProvider.notifier).state = 0.0;

      final dio = Dio();
      final dir = Directory('/storage/emulated/0/Download');
   
      final filePath = "${dir.path}/$fileName.pdf";

      debugPrint("Saving to: $filePath");

      await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 2),
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            ref.read(downloadProgressProvider.notifier).state =
                received / total;
          }
        },
      );
      Navigator.pop(context);
      await OpenFilex.open(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF downloaded successfully")),
      );
    } catch (e, s) {
      debugPrint("DOWNLOAD ERROR: $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    } finally {
      ref.read(isDownloadingProvider.notifier).state = false;
    }
  }

}