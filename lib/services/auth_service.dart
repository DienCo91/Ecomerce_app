import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/login_request.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:flutter_app/models/register_request.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<LoginResponse> loginUser(LoginRequest loginData) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/login'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': loginData.email, 'password': loginData.password}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      final String error = jsonDecode(response.body)["error"];
      Get.snackbar(
        "Error !",
        "${error}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception("Error login ");
    }
  }

  Future<LoginResponse> registerUser(RegisterRequest registerData) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/register'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(registerData.toJson()),
    );
    if (response.statusCode == 200) {
      Get.snackbar(
        "Sign up success",
        "Account created!",
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final String error = jsonDecode(response.body)["error"];
      Get.snackbar(
        "Error !",
        "${error}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception("Error register");
    }
  }
}
