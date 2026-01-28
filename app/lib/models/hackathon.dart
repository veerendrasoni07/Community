import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Hackathon {
  final String id;
  final String name;
  final String url;
  final String publicId;
  final String description;
  final String eventdate;
  final String eventTime;
  final String deadline;
  final int prize;
  final String duration;
  final String status;
  final int registered;
  final int totalTeam;
  final String venue;
  final int teamsize;
  final String level;
  final String link;
  Hackathon({
    required this.id,
    required this.name,
    required this.url,
    required this.publicId,
    required this.description,
    required this.eventdate,
    required this.eventTime,
    required this.duration,
    required this.deadline,
    required this.status,
    required this.registered,
    required this.totalTeam,
    required this.prize,
    required this.venue,
    required this.teamsize,
    required this.level,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url':url,
      'publicId':publicId,
      'description': description,
      'eventdate': eventdate,
      'status': status,
      'duration': duration,
      'deadline': deadline,
      'registered': registered,
      'prize': prize,
      'eventTime': eventTime,
      'totalTeam': totalTeam,
      'venue': venue,
      'teamsize': teamsize,
      'level': level,
      'link':link,
    };
  }

  factory Hackathon.fromJson(Map<String, dynamic> map) {
    return Hackathon(
      id: map['_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      url: map['image']['url']?.toString() ?? '',
      publicId: map['image']['public_id']?.toString() ?? '',
      level: map['level']?.toString() ?? '',
      duration: map['duration']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      registered: map['registered'] != null ? map['registered'] as int : 1,
      eventdate: map['eventdate']?.toString() ?? '',
      deadline: map['deadline']?.toString() ?? '',
      eventTime: map['eventTime']?.toString() ?? '',
      prize: map['prize'] != null ? map['prize'] as int : 0,
      status: map['status']?.toString() ?? '',
      totalTeam: map['totalTeam'] != null ? map['totalTeam'] as int : 0,
      venue: map['venue']?.toString() ?? '',
      teamsize: map['teamsize'] != null ? map['teamsize'] as int : 0,
      link: map['link']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

}
