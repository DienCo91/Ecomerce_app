import 'dart:convert';

import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/login_request.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<LoginResponse> loginUser(LoginRequest loginData) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': loginData.email,
        'password': loginData.password,
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception("Error login ");
    }
  }
}
