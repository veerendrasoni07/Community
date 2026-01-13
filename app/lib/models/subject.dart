import 'dart:convert';
import 'package:codingera2/models/pdf.dart';

class Subject{
  final String id;
  final String subject;
  final String noteType;
  final String semester;
  final List<Pdf> chapters;
  final DateTime createdAt;

  Subject({required this.id,required this.subject, required this.noteType, required this.semester, required this.chapters, required this.createdAt});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subject': subject,
      'semester': semester,
      'chapters': chapters,
      'noteType': noteType,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  String toJson()=> json.encode(toMap());


  factory Subject.fromMap(Map<String,dynamic> map){
    return Subject(
        id: map['_id'],
        subject: map['subject'],
        noteType: map['noteType'],
        semester: map['semester'],
        chapters: map['chapters'],
        createdAt: map['createdAt']
    );
  }

  factory Subject.fromJson(String source)=> Subject.fromMap(json.decode(source) as Map<String,dynamic>);



}