class User {
  final String name;
  final String gender;
  final String birthdate;
  final String email;
  final String password;
  final String numeroutent;
  final String createdAt;
  final String updatedAt;
  final int id;

  User(
      {required this.name,
      required this.gender,
      required this.birthdate,
      required this.email,
      required this.password,
      required this.numeroutent,
      required this.createdAt,
      required this.updatedAt,
      required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        email: json["email"],
        password: json["password"],
        numeroutent: json["numeroutent"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"]);
  }
  Map<String, dynamic> get toJson => {
        "id": id.toString(),
        "name": name,
        "gender": gender,
        "birthdate": birthdate,
        "email": email,
        "password": password,
        "numeroutent": numeroutent,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
