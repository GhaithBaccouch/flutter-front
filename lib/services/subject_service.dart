import 'dart:convert';

import 'package:client/models/subject_model.dart';
import 'package:http/http.dart' as http;

Future<List<Subject>> getAllSubjects() async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/subjects');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((subject) => Subject.fromJson(subject))
        .toList();
  } else {
    throw Exception('Failed to load subject');
  }
}

Future<Subject> getSubjectById(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/subjects/$id');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Subject.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load subject');
  }
}

Future<Subject> createSubject(Subject subject) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/subjects/create');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(subject.toJson()),
  );

  if (response.statusCode == 200) {
    return Subject.fromJson(json.decode(response.body));
  } else {
    print('Failed to create Subject. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to create Subject');
  }
}

Future<Subject> updateSubject(Subject subject) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/subjects/${subject.id}');
  final response = await http.put(uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(subject.toJson()));

  if (response.statusCode == 200) {
    return Subject.fromJson(json.decode(response.body));
  } else {
    print('Failed to update Subject. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to update Subject');
  }
}

Future<void> deleteSubject(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/subjects/$id');
  final response = await http.delete(uri);

  if (response.statusCode != 204) {
    print('Failed to delete Subject. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to delete Subject');
  }
}
