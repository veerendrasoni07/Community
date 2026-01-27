
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;


void showSnackBar(BuildContext context,String title ,String text,ContentType contentType) {
  ScaffoldMessenger.of(
    context,
  )..hideCurrentSnackBar()..showSnackBar(SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message:
      text,

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: contentType,
    ),)
  );
}

void manageHttpResponse(
  http.Response response,
  BuildContext context,
  VoidCallback onSuccess,
) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context,"Bad Request" ,'Bad Request: ${response.body}',ContentType.failure);
      break;
    case 401:
      showSnackBar(context,"Unauthorized" ,'Unauthorized: ${response.body}',ContentType.warning);
      break;
    case 403:
      showSnackBar(context, "Forbidden",'Forbidden: ${response.body}',ContentType.warning);
      break;
    case 404:
      showSnackBar(context,"Not Found" ,'Not Found: ${response.body}',ContentType.failure);
      break;
    case 500:
      showSnackBar(context,"Internal Server Error" ,'Internal Server Error: ${response.body}',ContentType.failure);
      break;
    default:
      showSnackBar(context, "Error",'Error ${response.statusCode}: ${response.body}',ContentType.failure);
  }
}






