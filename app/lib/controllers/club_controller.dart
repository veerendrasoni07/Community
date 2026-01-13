import 'dart:convert';

import 'package:codingera2/global_variable.dart';
import 'package:codingera2/models/club.dart';
import 'package:http/http.dart' as http;

class ClubController {
  Future<List<Club>> loadClub() async {
    try {
      // send an http request to fetch clubs...
      http.Response response = await http.get(
        Uri.parse('$uri/api/club'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print(data);
        List<Club> club = data.map((club) => Club.fromJson(club)).toList();
        return club;
      } else {
        print(response.body);
        throw Exception("Unable to load clubs");
      }
    } catch (e) {
      throw Exception("Failed to load clubs : $e");
    }
  }
}
