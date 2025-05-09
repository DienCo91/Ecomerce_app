class UserResponse {
  final int count;
  final int currentPage;
  final int totalPages;
  final List<Users> users;

  UserResponse({required this.count, required this.currentPage, required this.totalPages, required this.users});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var usersList = json['users'] as List;
    List<Users> users = usersList.map((userJson) => Users.fromJson(userJson)).toList();

    return UserResponse(
      count: json['count'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

class Users {
  final String provider;
  final String role;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime created;
  final int v;

  Users({
    required this.provider,
    required this.role,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.created,
    required this.v,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      provider: json['provider'],
      role: json['role'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      created: DateTime.parse(json['created']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'role': role,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'created': created.toIso8601String(),
      '__v': v,
    };
  }
}
