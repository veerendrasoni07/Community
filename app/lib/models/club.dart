// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:codingera2/models/user.dart';

class Club {
  final String id;
  final String image;
  final String clubname;
  final String techname;
  final String desc;
  final User clubLeader;
  final User clubManager;
  final String detailDec;
  final List<String> clubRule;
  final List<String> clubActivities;
  final String joinLink;


  Club({
    required this.id,
    required this.image,
    required this.clubname,
    required this.techname,
    required this.desc,
    required this.clubLeader,
    required this.clubManager,
    required this.detailDec,
    required this.clubRule,
    required this.clubActivities,
    required this.joinLink,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'clubname': clubname,
      'techname': techname,
      'desc': desc,
      'clubLeader': clubLeader,
      'clubManager':clubManager,
      'detailDes': detailDec,
      'clubRule': clubRule,
      'joinLink': joinLink,
      'clubActivities': clubActivities,
    };
  }

  factory Club.fromJson(Map<String, dynamic> map) {
    return Club(
      id: map['_id']?.toString() ?? '',
      joinLink: map['joinLink']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      clubname: map['clubname']?.toString() ?? '',
      techname: map['techname']?.toString() ?? '',
      desc: map['desc']?.toString() ?? '',
      clubLeader: User.fromMap(map['clubLeader']),
      clubManager: User.fromMap(map['clubManager']),
      detailDec: map['detailDes']?.toString() ?? '',
      clubRule: (map['clubRule'] as List<dynamic>?)?.cast<String>() ?? [],
      clubActivities: (map['clubActivities'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  
}
