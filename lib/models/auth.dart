class Auth {
  final String email;
  final String firstName;
  final String lastName;
  final String id;
  final String role;
  final String? phoneNumber;

  const Auth({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.role,
    this.phoneNumber,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    try {
      return Auth(
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        id: json['_id'] ?? json['id'] as String, // Kiểm tra _id hoặc id
        role: json['role'] as String,
        phoneNumber: json['phoneNumber'] as String?,
      );
    } catch (_) {
      throw const FormatException("Failed load Auth");
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      '_id': id,
      'role': role,
      'phoneNumber': phoneNumber,
    };
  }
}
