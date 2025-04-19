class RegisterRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  RegisterRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email,
        'firstName': String firstName,
        'lastName': String lastName,
        'password': String password,
      } =>
        RegisterRequest(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
        ),
      _ => throw const FormatException("Save Failed"),
    };
  }

  Map<String, String> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
    };
  }
}
