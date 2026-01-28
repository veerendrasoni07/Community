import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:codingera2/provider/hackathon_provider.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global_variable.dart';
import '../models/user.dart';



class AdminController {
  Future<Map<String, dynamic>> uploadImageToCloudinary(
      Map<String, dynamic> signedData, XFile filePath) async {

    try {
      final req = http.MultipartRequest("POST", Uri.parse(signedData['uploadUrl']))
        ..fields['api_key'] = signedData['apiKey'].toString()
        ..fields['timestamp'] = signedData['timestamp'].toString()
        ..fields['signature'] = signedData['signature'].toString()
        ..fields['folder'] = signedData['folder']
        ..files.add(await http.MultipartFile.fromPath("file", filePath.path));

      final res = await req.send();
      final body = await res.stream.bytesToString();

      if (res.statusCode != 200) {
        throw Exception("Image upload failed");
      }
      print("Its uploadedd to the cloudinary");
      return jsonDecode(body);
    } on Exception catch (e) {
      // TODO
      print(e);
      rethrow;
    }
  }
  Future<Map<String, dynamic>> sign(String type,String token,BuildContext context,WidgetRef ref) async {
    final res = await AuthController().sendRequest(request: (token)async{
      return  await http.post(
        Uri.parse("$uri/api/cloudinary/sign"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token
        },
        body: jsonEncode({"type": type}),
      );
    },context: context,ref: ref);
    print("we got the signed data");
    return jsonDecode(res.body);
  }


  Future<void> uploadHackathon({
    required String name,
    required String description,
    required WidgetRef ref,
    required BuildContext context,
    required String venue,
    required DateTime eventDate,
    required DateTime deadline,
    required int teamSize,
    required int totalTeam,
    required String eventTime,
    required XFile image,
    required String duration,
    required String link,
    required String level,
    required int prize,
    required String status
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final signedData = await sign('image', token!, context, ref);
      final uploadImage = await uploadImageToCloudinary(signedData, image);
      final imageUrl = uploadImage["secure_url"];
      final publicId = uploadImage['public_id'];
      final response = await AuthController().sendRequest(request: (token)async{
        return await http.post(
          Uri.parse('$uri/api/upload-hackathon'),
          body: jsonEncode({
            "name": name,
            "image": {
              "url": imageUrl,
              "public_id": publicId,
            },
            "description": description,
            "eventdate": eventDate.toIso8601String(),
            "eventTime": eventTime,
            "deadline": deadline.toIso8601String(),
            "prize": prize,
            "venue": venue,
            "duration": duration,
            "teamsize": teamSize,
            "totalTeam": totalTeam,
            "level": level,
            "link": link,
            "status": status
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
      }, context: context, ref: ref);
      if (response.statusCode == 200) {
        debugPrint("Hackathon uploaded successfully");
      } else {
        debugPrint("Upload failed: ${response.body}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<User>> getAllMembersOfCommunity({required BuildContext context,required WidgetRef ref}) async {
      try{
      http.Response response = await AuthController().sendRequest(request: (token)async{
        return await http.get(
          Uri.parse('$uri/api/community-member'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
      }, context: context, ref: ref);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<User> members = data.map((e) => User.fromMap(e)).toList();
        return members;
      } else {
        print("Something went wrong asfasfgnaskgjfnaskjgfas");
        print(response.body);
        throw Exception("Something went wrong");
      }
    } catch (e) {
      print(e);
      throw Exception("Something went wrong");
    }
  }

  Future<void> uploadClub({
    required String clubname,
    required String techname,
    required String desc,
    required String clubLeader,
    required String clubManager,
    required List<String> clubRule,
    required List<String> clubActivities,
    required XFile image,
    required String detailDesc,
    required String formFilePath,
    required WidgetRef ref,
    required BuildContext context,

})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final signedData = await sign('image', token!, context, ref);

      final uploadImage = await uploadImageToCloudinary(signedData, image);
      final imageUrl = uploadImage["secure_url"];
      final publicId = uploadImage['public_id'];

      // multipart request because i also have to upload club form to the cloudinary which is a pdf file
      final url = Uri.parse('$uri/api/upload-pdf');
      final request = http.MultipartRequest("POST", url);
      request.files.add(await http.MultipartFile.fromPath("pdf", formFilePath));
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Club form uploaded successfully");
        final uploadBody = await response.stream.bytesToString();
        final pdfLink = jsonDecode(uploadBody)["pdf"];
        final pdfPublicId = jsonDecode(uploadBody)['public_id'];

        final res = await http.post(
          Uri.parse('$uri/api/upload-club'),
            body: jsonEncode({
              "clubname": clubname,
              "techname": techname,
              "desc": desc,
              "clubLeader": clubLeader,
              "clubManager": clubManager,
              "clubRule": clubRule,
              "clubActivities": clubActivities,
              "image": {
                "imageUrl": imageUrl,
                "image_public_id": publicId
              },
              "detailDesc": detailDesc,
              "form": {
                "formUrl":pdfLink,
                "form_public_id":pdfPublicId
              },
            }),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            });

        if(res.statusCode == 200){
          showSnackBar(context,"Success","Club uploaded successfully",ContentType.success);
        }else{
          showSnackBar(context,"Failure" ,"Something went wrong",ContentType.failure);
          print(res.body);
        }
      }

    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }
  }

  Future<void> uploadBanner({required XFile bannerFile, required BuildContext context,required WidgetRef ref})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      Map<String, dynamic> signData = await sign("image", token!, context, ref);
      print(signData);
      print(bannerFile.path);
      final uploadImage = await uploadImageToCloudinary(signData,bannerFile);
      final imageUrl = uploadImage['secure_url'];
      final publicId = uploadImage['public_id'];
      print("letsss gooooo");
      http.Response response = await http.post(
          Uri.parse('$uri/api/upload-banner'),
          body: jsonEncode({
            "image": {
              "url": imageUrl,
              "public_id": publicId
            },
          }),
        headers: <String,String>{
            "Content-Type":"application/json; charset=UTF-8"
        }
      );
      if(response.statusCode == 200){
        if(context.mounted){
          showSnackBar(context, "Success","Banner uploaded successfully",ContentType.success);
          Navigator.pop(context);
        }
      }else{
        print(response.body);
        if(context.mounted){
          showSnackBar(context, "Failure","Something went wrong",ContentType.failure);
        }
      }
    }catch(e){
      print(e.toString());
      throw Exception("Something went wrong");
    }
  }



  Future<void> deleteHackathon({required String hackathonId,required BuildContext context,required WidgetRef ref})async{
    try{
      http.Response response = await http.delete(
          Uri.parse('$uri/api/delete-hackathon'),
        body: jsonEncode({
          'hackathonId':hackathonId,
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        ref.read(hackathonProvider.notifier).deleteHackathon(hackathonId);
        if(context.mounted){
          showSnackBar(context, "Success","Hackathon deleted successfully",ContentType.success);
        }
      }


    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }
  }


  Future<void> hackathonUpdate({
    required Map<String,dynamic> details,
    required String currentImage,
    required String hackathonId,
    required WidgetRef ref,
    required BuildContext context,
    required XFile? image,
})async{
    try{
      if(image!=null){
        print("-------------------------------------hackathon update change in image-------------------------------");
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final token = preferences.getString('token');
        final signedData = await sign('image', token!, context, ref);
        final uploadImage = await uploadImageToCloudinary(signedData, image);
        final imageUrl = uploadImage["secure_url"];
        details.putIfAbsent("image", () => details['image'] = {
          "url": imageUrl,
          "public_id": uploadImage["public_id"],
        });
        final response = await http.put(
          Uri.parse('$uri/api/hackathon-update'),
          body: jsonEncode({
            "data":details,
            "hackathonId": hackathonId
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }
        );
        if (response.statusCode == 200) {
          showSnackBar(context, "Success", "Hackathon Updated Successfully", ContentType.success);
          final data = jsonDecode(response.body);
          final hackathon = Hackathon.fromJson(data);
          ref.read(hackathonProvider.notifier).updateHackathon(hackathon);
          debugPrint("Hackathon updated successfully");
        } else {
          debugPrint("Upload failed: ${response.body}");
          throw Exception("Something went wrong");
        }
      }else{

        print("-------------------------------------hackathon update without change in image-------------------------------");
        final response = await http.put(
            Uri.parse('$uri/api/hackathon-update'),
            body: jsonEncode({
              "data":details,
              "hackathonId": hackathonId,
            }),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            }
        );
        if (response.statusCode == 200) {
          showSnackBar(context, "Success", "Hackathon Updated Successfully", ContentType.success);
          final data = jsonDecode(response.body);
          final hackathon = Hackathon.fromJson(data);
          ref.read(hackathonProvider.notifier).updateHackathon(hackathon);
          debugPrint("Hackathon updated successfully");
        } else {
          debugPrint("Upload failed: ${response.body}");
          throw Exception("Something went wrong");
        }
      }

    }catch(e){
      print(e);
      throw Exception("Something went wrong");
    }
  }
  




}
