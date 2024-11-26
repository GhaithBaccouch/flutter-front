import 'dart:convert';

import 'package:client/models/class_model.dart';
import 'package:client/models/department_model.dart';
import 'package:http/http.dart' as http;

Future<List<Department>> getDepartments() async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/departments');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((department) => Department.fromJson(department))
        .toList();
  } else {
    throw Exception('Failed to load departments');
  }
}

Future<Department> getDepartmentById(String id) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8055/api/v1/departments/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Department.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load department from API');
  }
}

Future<Department> createDepartment(Department department) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/departments');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(department.toJson()),
  );

  if (response.statusCode == 200) {
    return Department.fromJson(json.decode(response.body));
  } else {
    print('Failed to create department. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to create department');
  }
}

Future<Department> updateDepartment(Department department) async {
  final uri =
      Uri.parse('http://10.0.2.2:8055/api/v1/departments/${department.id}');
  final response = await http.put(uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(department.toJson()));

  if (response.statusCode == 200) {
    return Department.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update Department');
  }
}

Future<void> deleteDepartment(String id) async {
  final response = await http.delete(
    Uri.parse('http://10.0.2.2:8055/api/v1/departments/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 204) {
    print('Failed to delete department. Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to delete department');
  }
}

Future<List<Class>> getClassesByDepartmentId(String id) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/departments/$id/classes');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((classRoom) => Class.fromJson(classRoom))
        .toList();
  } else {
    throw Exception('Failed to load classes');
  }
}
