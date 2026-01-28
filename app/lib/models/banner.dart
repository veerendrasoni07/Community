import 'dart:convert';

class BannerModel {
  final String id;
  final String url;
  final String publicId;
  BannerModel({
    required this.id,
    required this.url,
    required this.publicId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'publicId': publicId,
    };
  }

  factory BannerModel.fromJson(Map<String, dynamic> map) {
    return BannerModel(
      id: map['_id'] as String,
      url: map['image']['url'] as String,
      publicId: map['image']['public_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  
}
