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
      id: map['_id'] as String,
      joinLink: map['joinLink'] as String,
      image: map['image'] as String,
      clubname: map['clubname'] as String,
      techname: map['techname'] as String,
      desc: map['desc'] as String,
      clubLeader: map['clubLeader'] as User,
      clubManager: map['clubManager'] as User,
      detailDec: map['detailDes'] as String ?? '',
      clubRule: map['clubRule'] as List<String> ?? [],
      clubActivities: map['clubActivities'] as List<String> ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  
}
