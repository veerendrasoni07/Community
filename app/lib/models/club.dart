// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:codingera2/models/user.dart';

class Club {
  final String id;
  final String imageUrl;
  final String imagePublicId;
  final String clubname;
  final String techname;
  final String desc;
  final User clubLeader;
  final User clubManager;
  final String detailDec;
  final List<String> clubRule;
  final List<String> clubActivities;
  final String formUrl;
  final String formPublicId;



  Club({
    required this.id,
    required this.imageUrl,
    required this.imagePublicId,
    required this.clubname,
    required this.techname,
    required this.desc,
    required this.clubLeader,
    required this.clubManager,
    required this.detailDec,
    required this.clubRule,
    required this.clubActivities,
    required this.formUrl,
    required this.formPublicId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': imageUrl,
      'imagePublicId': imagePublicId,
      'clubname': clubname,
      'techname': techname,
      'desc': desc,
      'clubLeader': clubLeader,
      'clubManager':clubManager,
      'detailDes': detailDec,
      'clubRule': clubRule,
      'formUrl': formUrl,
      'form_public_id': formPublicId,
      'clubActivities': clubActivities,
    };
  }

  factory Club.fromJson(Map<String, dynamic> map) {
    return Club(
      id: map['_id']?.toString() ?? '',
      formUrl: map['form']['formUrl']?.toString() ?? '',
      formPublicId: map['form']['form_public_id']?.toString() ?? '',
      imageUrl: map['image']['imageUrl']?.toString() ?? '',
      imagePublicId: map['image']['image_public_id']?.toString() ?? '',
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
