import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/login_request.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:flutter_app/models/register_request.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/firebase_api.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<LoginResponse> loginUser(LoginRequest loginData) async {
    String? deviceToken = await FirebaseApi().getFCMToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/login'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'email': loginData.email,
        'password': loginData.password,
        'deviceToken': deviceToken ?? "",
      }),
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
    String? deviceToken = await FirebaseApi().getFCMToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/register'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({...registerData.toJson(), 'deviceToken': deviceToken}),
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

  Future<Auth> updateUser(Auth user) async {
    AuthController authController = Get.find();
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/user"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
      body: jsonEncode({'profile': user}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataRes = jsonDecode(response.body)['user'];
      return Auth.fromJson(dataRes);
    } else {
      throw Exception("UpdateUser Fail");
    }
  }

  Future<String> resetPassword({required String confirmPassword, required String password}) async {
    AuthController authController = Get.find();
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/auth/reset"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
      body: jsonEncode({'confirmPassword': confirmPassword, 'password': password}),
    );

    if (response.statusCode == 200) {
      final String dataRes = jsonDecode(response.body)['message'];
      showSnackBar(message: dataRes);
      return dataRes;
    } else {
      final String dataRes = jsonDecode(response.body)['error'];
      showSnackBar(message: dataRes, backgroundColor: Colors.red);
      throw Exception("Error resetPassword");
    }
  }

  Future<LoginResponse?> signInWithGoogle() async {
    await Firebase.initializeApp();
    String? deviceToken = await FirebaseApi().getFCMToken();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    final idToken = await userCredential.user?.getIdToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/auth/google"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"idToken": idToken, 'deviceToken': deviceToken}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed Login GG");
    }
  }

  Future<UserResponse> getAllUser({required int page, required int limit}) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/user?page=$page&limit=$limit'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error register");
    }
  }

  Future<Auth> fetchCurrentUser(String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/user/me');
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['user'];
      return Auth.fromJson(jsonData);
    } else {
      throw Exception("Error get me");
    }
  }

  Future logout() async {
    String? token = getToken() ?? "";

    final url = Uri.parse('${ApiConstants.baseUrl}/api/auth/logout');
    final response = await http.post(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Error logout");
    }
  }

  Future verify({required String email}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/auth/verify');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email}),
    );
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 404) {
      showSnackBar(message: "User not found", backgroundColor: Colors.red);
      throw Exception("User not found");
    } else {
      throw Exception("Error Verify");
    }
  }

  Future sendOtp({required String email, required String code}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/auth/verify-code');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email, 'code': code}),
    );
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 404) {
      showSnackBar(message: "User not found", backgroundColor: Colors.red);
      throw Exception("User not found");
    }
    if (response.statusCode == 400) {
      showSnackBar(message: "Verification code is invalid or expired", backgroundColor: Colors.red);
      throw Exception("Verification code is invalid or expired");
    } else {
      throw Exception("Error sendOtp");
    }
  }

  Future changePasswordOtp({required String email, required String password}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/auth/change-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 404) {
      showSnackBar(message: "User not found", backgroundColor: Colors.red);
      throw Exception("User not found");
    } else {
      throw Exception("Error ChangePasswordOtp");
    }
  }
}
