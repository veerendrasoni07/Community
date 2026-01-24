import 'dart:convert';

import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/global_variable.dart';
import 'package:codingera2/models/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' ;
import 'package:http/http.dart' as http;

class BannerController {
  // load banners...
  Future<List<BannerModel>> loadBanner({required BuildContext context, required WidgetRef ref}) async {
    try {
      // send an http request to fetch the banners

     http.Response response = await AuthController().sendRequest(request: (token)async{
        return await http.get(
          Uri.parse('$uri/api/banner'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );

      }, context: context, ref: ref);
      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banner =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banner;
      } else {
        throw Exception("Unable to load banners");
      }
    } catch (e) {
      throw Exception("Failed to load banners");
    }
  }
}
