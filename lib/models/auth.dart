class Auth {
  final String email;
  final String firstName;
  final String lastName;
  final String id;
  final String role;

  const Auth({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.role,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email,
        'lastName': String lastName,
        'firstName': String firstName,
        'id': String id,
        'role': String role,
      } =>
        Auth(
          email: email,
          lastName: lastName,
          firstName: firstName,
          id: id,
          role: role,
        ),
      _ => throw const FormatException("Failed load album"),
    };
  }
}
