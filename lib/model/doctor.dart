import 'user.dart';

class Doctor extends User {
  final String specialty;
  final int rating;
  final String imageUrl;

  Doctor({
    required String name,
    required String gender,
    required String birthdate,
    required String email,
    required String password,
    required String numeroutent,
    required String createdAt,
    required String updatedAt,
    required int id,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  }) : super(
            name: name,
            gender: gender,
            birthdate: birthdate,
            email: email,
            password: password,
            numeroutent: numeroutent,
            createdAt: createdAt,
            updatedAt: updatedAt,
            id: id);

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json["id"],
      name: json["name"],
      gender: json["gender"],
      birthdate: json["birthdate"],
      email: json["email"],
      password: json["password"],
      numeroutent: json["numeroutent"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      specialty: json["specialty"],
      rating: json["rating"],
      imageUrl: json["imageUrl"],
    );
  }

  @override
  Map<String, dynamic> get toJson => super.toJson
    ..addAll({
      "specialty": specialty,
      "ranking": rating,
      "imageUrl": imageUrl,
    });
}
