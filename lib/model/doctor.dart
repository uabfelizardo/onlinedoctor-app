import 'user.dart';

class Doctor extends User {
  final String specialty;
  final int rating;
  final String imageUrl;

  Doctor({
    required String name,
    required String gender,
    required DateTime birthdate,
    required String email,
    required String password,
    required String numeroUtente,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int userId,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  }) : super(
          name: name,
          gender: gender,
          birthDate: birthdate,
          email: email,
          password: password,
          numeroUtente: numeroUtente.toString(),
          createdAt: createdAt,
          updatedAt: updatedAt,
          id: userId,
        );

  factory Doctor.fromJson(Map<String, dynamic> json) {
  final doctorInfo = json['doctorInformation'] ?? {};
  final specialties = json['specialties'] ?? [];
  final specialty = specialties.isNotEmpty ? specialties[0]['specialty']['description'] : '';

  return Doctor(
    userId: doctorInfo['user_id'] ?? 0,
    name: doctorInfo['name'] ?? '',
    gender: doctorInfo['gender'] ?? '',
    birthdate: doctorInfo['birthdate'] != null ? DateTime.parse(doctorInfo['birthdate']) : DateTime.now(),
    email: doctorInfo['email'] ?? '',
    password: doctorInfo['password'] ?? '',
    numeroUtente: doctorInfo['numeroutent']?.toString() ?? '',
    createdAt: doctorInfo['createdAt'] != null ? DateTime.parse(doctorInfo['createdAt']) : DateTime.now(),
    updatedAt: doctorInfo['updatedAt'] != null ? DateTime.parse(doctorInfo['updatedAt']) : DateTime.now(),
    specialty: specialty,
    rating: json['rating'] ?? 0,
    imageUrl: doctorInfo['img'] ?? '',
  );
}
}
