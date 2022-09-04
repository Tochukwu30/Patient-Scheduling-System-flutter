class BioPatient {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? homeAddress;

  const BioPatient({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.homeAddress,
  });

  factory BioPatient.fromJson(Map<String, dynamic> json) {
    return BioPatient(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      phoneNumber: json["phone_no"],
      email: json["email"],
      homeAddress: json["home_address"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> bio = <String, dynamic>{};
    bio["id"] = id;
    bio["first_name"] = firstName;
    bio["last_name"] = lastName;
    bio["phone_no"] = phoneNumber;
    bio["email"] = email;
    bio["home_address"] = homeAddress;
    return bio;
  }
}
