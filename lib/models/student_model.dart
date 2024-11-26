import 'package:client/models/class_model.dart';

class Student {
  String? id;
  String firstName;
  String lastName;
  String dateOfBirth;
  Class? classRoom;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.classRoom,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      classRoom: Class.fromJson(json['classRoom']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'classRoom': classRoom?.toJson(),
    };
  }
}
