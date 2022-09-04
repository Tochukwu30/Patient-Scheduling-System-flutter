class AccessToken {
  final String refresh;
  final String access;
  final int id;
  final String email;
  final String role;

  const AccessToken(
      {required this.refresh,
      required this.access,
      required this.id,
      required this.email,
      required this.role});

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
        refresh: json["refresh"],
        access: json["access"],
        id: json["id"],
        email: json["email"],
        role: json["role"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> token = <String, dynamic>{};
    token["refresh"] = refresh;
    token["access"] = access;
    token["id"] = id;
    token["email"] = email;
    token["role"] = role;
    return token;
  }
}
