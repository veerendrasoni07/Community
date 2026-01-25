import 'dart:convert';

import 'package:codingera2/global_variable.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:http/http.dart' as http;

class HackathonController {
  // fetch the hackathon details

  Future<List<Hackathon>> loadHackathon() async {
    try {
      // send a http request to fetch details
      http.Response response = await http.get(
        Uri.parse('$uri/api/hackathon'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Hackathon> hackathon =
            data.map((hackathon) => Hackathon.fromJson(hackathon)).toList();
        return hackathon;
      } else {
        print(response.body);
        throw Exception("Failed to fetch details!");
      }
    } catch (e) {
      throw Exception("Error : $e");
    }
  }
}
