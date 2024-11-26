import 'dart:convert';

import 'package:client/models/student_model.dart';
import 'package:http/http.dart' as http;

Future<List<Student>> getAllStudents() async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/students');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((student) => Student.fromJson(student))
        .toList();
  } else {
    throw Exception('Failed to load student');
  }
}

Future<Student> getStudentById(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/students/$id');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Student.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load student');
  }
}

Future<Student> createStudent(Student student) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/students/create');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      print('Failed to create student. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to create student');
    }
  } catch (error) {
    print('Error creating student: $error');
    throw Exception('Failed to create student');
  }
}

Future<Student> updateStudent(Student student) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/students/${student.id}');
  final response = await http.put(uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()));

  if (response.statusCode == 200) {
    return Student.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update student');
  }
}

Future<Student> deleteStudent(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/students/$id');
  final response = await http.delete(uri);

  if (response.statusCode == 200) {
    return Student.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete student');
  }
}
