import 'package:client/models/department_model.dart';
import 'package:client/models/subject_model.dart';

class Class {
  String? id;
  String name;
  int numberOfStudents;
  Department? department;
  List<Subject>? subjects;

  Class({
    this.id,
    required this.name,
    required this.numberOfStudents,
    this.department,
    this.subjects,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      name: json['name'],
      numberOfStudents: json['numberOfStudents'],
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      subjects: json['subjects'] != null
          ? (json['subjects'] as List)
              .map((subject) => Subject.fromJson(subject))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'numberOfStudents': numberOfStudents,
      'department': department?.toJson(),
      'subjects': subjects?.map((subject) => subject.toJson()).toList(),
    };
  }
}
