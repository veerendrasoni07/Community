import 'dart:convert';

import 'package:codingera2/global_variable.dart';
import 'package:codingera2/provider/auth_manager_provider.dart';
import 'package:codingera2/provider/token_provider.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:codingera2/services/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/screens/main_screen.dart' show MainScreen;



  //sign up
  class AuthController{

  Future<void> signUp({required String fullname,required String username,required String email, required String password,required String gender,required BuildContext context,required WidgetRef ref})async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/sign-up'),
        body: jsonEncode({
          'fullname':fullname,
          'email':email,
          'password':password,
          'gender':gender,
          'username':username
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        final refreshToken = data['refreshToken'];
        final token = data['accessToken']; // access token
        final userJson = jsonEncode(data['user']);
        preferences.setString('user', userJson);
        preferences.setString('token', token);
        preferences.setString('refreshToken', refreshToken);
        ref.read(userProvider.notifier).setUser(userJson);
        ref.read(tokenProvider.notifier).setToken(token);
        if(context.mounted){
          showSnackBar(context, 'Account created successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false, // remove all previous routes
          );
        }
      }
      else{
        print(response.body);
        throw Exception('Failed to create account');
      }

    }catch(e){
      print(e);
    }
  }

  Future<void> login({required String email, required String password,required BuildContext context,required WidgetRef ref})async{
    try{
      showDialog(context: context, builder: (context){
        return Center(child: CircularProgressIndicator(color: Colors.blue.shade900,),);
      });
      http.Response response = await http.post(
          Uri.parse('$uri/api/sign-in'),
          body: jsonEncode({
            'email':email,
            'password':password,
          }),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
          }
      );

      if(response.statusCode == 200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        final token = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = data['user'];
        final userJson = jsonEncode(user);
        await preferences.setString('user', userJson);
        await preferences.setString('token', token);
        await preferences.setString('refreshToken', refreshToken);
        ref.read(userProvider.notifier).setUser(userJson);
        ref.read(tokenProvider.notifier).setToken(token);
        if(context.mounted){
          Navigator.pop(context);
          showSnackBar(context, 'Logged in successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false, // remove all previous routes
          );
        }
      }
      else{
        throw Exception('Failed to create account');
      }

    }catch(e){
      print(e);
    }
  }




  Future<bool> usernameCheck(String username)async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/username-check/$username'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body)['msg'];
        return data;
      }else{
        throw Exception('Failed to check username');
      }
    }
    catch(e){
      throw Exception(e);
    }
  }
  
  Future<void> updateUserProfile({required String fullname,required int phone,required String laptop,required String location,required int currentSemester,required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response =  await sendRequest(request: (token)async{
        return await http.put(
            Uri.parse('$uri/api/update-profile'),
            body: jsonEncode({
              "details": {
                'fullname':fullname,
                "phone":phone,
                'currentSemester':currentSemester,
                'location':location,
                'laptop':laptop
              }
            }),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      }, context: context, ref: ref);
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final user = data['user'];
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('user');
        final userJson = jsonEncode(user);
        await preferences.setString('user', userJson);
        ref.read(userProvider.notifier).setUser(userJson);
        if(context.mounted){
          showSnackBar(context, 'Profile updated successfully');
        }
      }else{
        print(response.body);
        throw Exception('Failed to update profile');
      }
    }catch(e){
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<http.Response> sendRequest({
    required Future<http.Response> Function(String token) request,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      if (token == null) {
        await ref.read(authManagerProvider.notifier).logout(context);
        throw Exception('No access token');
      }

      http.Response response = await request(token);

      if (response.statusCode == 401) {
        final refreshed = await refreshTokenMethod();

        if (!refreshed) {
          await ref.read(authManagerProvider.notifier).logout(context);
          throw Exception('Session expired');
        }

        token = preferences.getString('token');
        if (token == null) {
          throw Exception('Token refresh failed');
        }
        response = await request(token);
      }
      return response;
    } catch (e) {
      debugPrint('Request error: $e');
      rethrow;
    }
  }

  Future<bool> refreshTokenMethod() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rToken = preferences.getString('refreshToken');
      if (rToken == null) return false;
      final response = await http.post(
        Uri.parse('$uri/api/refresh-token'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"refreshToken": rToken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await preferences.setString('token', data['accessToken']);
        await preferences.setString('refreshToken', data['refreshToken']);
        return true;
      }
      if (response.statusCode == 401) {
        return false;
      }
      throw Exception('Refresh token failed');
    } catch (e) {
      debugPrint('Refresh error: $e');
      return false;
    }
  }



  Future<bool> getOTP(String email,BuildContext context)async {
    try{
      http.Response response = await  http.post(
          Uri.parse('$uri/api/get-otp'),
        body: jsonEncode({
          "email":email
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        },
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        showSnackBar(context, "OTP is sent to your email");
        return data['success'];
      }
      else{
        print(response.body);
        throw Exception('Failed to get OTP');
      }
    }catch(e){
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> verifyOTP(String email,int otp)async {
    try{
      http.Response response = await  http.post(
        Uri.parse('$uri/api/get-otp'),
        body: jsonEncode({
          "email":email,
          "otp":otp
        }),
        headers: <String,String>{
          'Content-Type':'application/json; charset=UTF-8'
        },
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['success'];
      }
      else{
        print(response.body);
        throw Exception('Failed to get OTP');
      }
    }catch(e){
      print(e);
      throw Exception(e);
    }
  }

  Future<void> resetPassword({required String email ,required String password,required BuildContext context})async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/reset-password'),
        body: jsonEncode({
          "password":password,
          "email":email
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        showSnackBar(context, data['msg']);
      }
      else{
        print(response.body);
        throw Exception('Failed to reset password');
      }
    }catch(e){
      print(e.toString());
      throw Exception(e.toString());
    }
  }




  }


