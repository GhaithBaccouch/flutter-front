import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Attendance.dart';


class AttendanceService {
  final String _baseUrl = "http://localhost:8080/api/v1/attendances";

  Future<Attendance> createAttendance(Attendance attendance) async {
    var request = http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(attendance),
    );

    var response = await request.timeout(Duration(seconds: 10));

    if (response.statusCode == 201) {
      // L'absence a été créée avec succès
      return Attendance.fromJson(jsonDecode(response.body));
    } else {
      // Une erreur s'est produite
      throw Exception("Une erreur s'est produite lors de la création de l'absence");
    }
  }
}
