import 'dart:convert';

import 'package:client/models/class_model.dart';
import 'package:client/models/student_model.dart';
import 'package:http/http.dart' as http;

Future<List<Class>> getAllClasses() async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/classes');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((student) => Class.fromJson(student))
        .toList();
  } else {
    throw Exception('Failed to load student');
  }
}

Future<Class> getClassById(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/classes/$id');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Class.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load student');
  }
}

Future<Class> createClass(Class classRoom) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/classes/create');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(classRoom.toJson()),
  );

  if (response.statusCode == 200) {
    return Class.fromJson(json.decode(response.body));
  } else {
    print('Failed to create class. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to create class');
  }
}

Future<Class> updateClass(Class classRoom) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/classes/${classRoom.id}');
  final response = await http.put(uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(classRoom.toJson()));

  if (response.statusCode == 200) {
    return Class.fromJson(json.decode(response.body));
  } else {
    print('Failed to update class. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to update class');
  }
}

Future<void> deleteClass(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/classes/$id');
  final response = await http.delete(uri);

  if (response.statusCode != 204) {
    print('Failed to delete class. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to delete class');
  }
}

Future<List<Student>> getStudentsByClassId(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/classes/$id/students');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((student) => Student.fromJson(student))
        .toList();
  } else {
    throw Exception('Failed to load student');
  }
}
