class User {
  // This class models a user

  final int id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;

  const User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      role: json["role"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }

  toJson() {
    Map<String, dynamic> user = <String, dynamic>{};
    user["id"] = id;
    user["email"] = email;
    user["role"] = role;
    user["first_name"] = firstName;
    user["last_name"] = lastName;
    return user;
  }
}
