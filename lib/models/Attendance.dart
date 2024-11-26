import 'dart:convert';

class Attendance {
  String nce;
  String codMat;
  DateTime dateA;
  double nha;

  Attendance({
    required this.nce,
    required this.codMat,
    required this.dateA,
    required this.nha,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      nce: json['nce'],
      codMat: json['codMat'],
      dateA: DateTime.parse(json['dateA']),
      nha: json['nha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nce': nce,
      'codMat': codMat,
      'dateA': dateA.toIso8601String(),
      'nha': nha,
    };
  }
}
