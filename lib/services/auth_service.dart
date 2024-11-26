import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:client/models/user_model.dart';

Future<User> signIn(String email, String password) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/users/sign-in');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('Failed to sign in. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to sign in');
    }
  } catch (e) {
    print('Failed to sign in. Error: $e');
    throw Exception('Failed to sign in');
  }
}

Future<User> signUp(User user) async {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/users/sign-up');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('Failed to sign up. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to sign up');
    }
  } catch (e) {
    print('Failed to sign up. Error: $e');
    throw Exception('Failed to sign up');
  }
}

void signOut() {
  final uri = Uri.parse('http://10.0.2.2:8055/api/v1/users/sign-out');
  http.post(uri);
}
