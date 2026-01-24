import 'dart:convert';
import 'dart:io';

import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:flutter/foundation.dart';
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
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final signedData = await sign('image', token!, context, ref);
      final uploadImage = await uploadImageToCloudinary(signedData, image);
      final imageUrl = uploadImage["secure_url"];
      
      
      final response = await http.post(
        Uri.parse('$uri/api/upload-hackathon'),
        body: jsonEncode({
          "name": name,
          "image": imageUrl,
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
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Hackathon uploaded successfully");
      } else {
        debugPrint("Upload failed: ${response.body}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<User>> getAllMembersOfCommunity() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/community-member'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
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
    required String joinLink,
    required WidgetRef ref,
    required BuildContext context,

})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final signedData = await sign('image', token!, context, ref);
      final uploadImage = await uploadImageToCloudinary(signedData, image);
      final imageUrl = uploadImage["secure_url"];

      final response = await http.post(
        Uri.parse('$uri/api/upload-club'),
          body: jsonEncode({
            "clubname": clubname,
            "techname": techname,
            "desc": desc,
            "clubLeader": clubLeader,
            "clubManager": clubManager,
            "clubRule": clubRule,
            "clubActivities": clubActivities,
            "image": imageUrl,
            "detailDesc": detailDesc,
            "joinLink": joinLink,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if(response.statusCode == 200){
        showSnackBar(context, "Club uploaded successfully");
      }else{
        showSnackBar(context, "Something went wrong");
        print(response.body);
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
      print("letsss gooooo");
      http.Response response = await http.post(
          Uri.parse('$uri/api/upload-banner'),
          body: jsonEncode({
            "image": imageUrl,
          }),
        headers: <String,String>{
            "Content-Type":"application/json; charset=UTF-8"
        }
      );
      if(response.statusCode == 200){
        if(context.mounted){
          showSnackBar(context, "Banner uploaded successfully");
          Navigator.pop(context);
        }
      }else{
        print(response.body);
        if(context.mounted){
          showSnackBar(context, "Something went wrong");
        }
      }
    }catch(e){
      print(e.toString());
      throw Exception("Something went wrong");
    }
  }
  




}
