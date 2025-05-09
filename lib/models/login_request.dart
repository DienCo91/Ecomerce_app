// class LoginRequest {
//   final String email;
//   final String password;

//   const LoginRequest({required this.email, required this.password});

//   factory LoginRequest.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {'email': String email, 'password': String password} => LoginRequest(email: email, password: password),
//       _ => throw const FormatException("Failed load LoginRequest"),
//     };
//   }
// }
