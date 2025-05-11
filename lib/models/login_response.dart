import 'package:flutter_app/models/auth.dart';

class LoginResponse {
  final bool success;
  final String token;
  final Auth user;

  const LoginResponse({required this.success, required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(success: json['success'], token: json['token'], user: Auth.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'token': token, 'user': user.toJson()};
  }
}
