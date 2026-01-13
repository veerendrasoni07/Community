import 'dart:convert';
class Pdf {
  final String id;
  final String subject;
  final String semester;
  final String chapter;
  final String pdf;
  final DateTime createdAt;

  Pdf({required this.id,required this.subject, required this.semester, required this.chapter, required this.pdf, required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subject': subject,
      'semester': semester,
      'chapter': chapter,
      'pdf': pdf,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Pdf.fromMap(Map<String, dynamic> map) {
    return Pdf(
      id: map['_id'] as String,
      subject: map['subject'] as String,
      semester: map['semester'] as String,
      chapter: map['chapter'] as String,
      pdf: map['pdf'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Pdf.fromJson(String source) => Pdf.fromMap(json.decode(source) as Map<String, dynamic>);
}
