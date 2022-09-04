class BioDoctor {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? speciality;
  final String? homeAddress;
  final String? officeAddress;

  const BioDoctor({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.speciality,
    this.homeAddress,
    this.officeAddress,
  });

  factory BioDoctor.fromJson(Map<String, dynamic> json) {
    return BioDoctor(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      phoneNumber: json["phone_no"],
      email: json["email"],
      speciality: json["speciality"],
      homeAddress: json["home_address"],
      officeAddress: json["office_address"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> bio = <String, dynamic>{};
    bio["id"] = id;
    bio["first_name"] = firstName;
    bio["last_name"] = lastName;
    bio["phone_no"] = phoneNumber;
    bio["email"] = email;
    bio["speciality"] = speciality;
    bio["home_address"] = homeAddress;
    bio["office_address"] = officeAddress;
    return bio;
  }
}
