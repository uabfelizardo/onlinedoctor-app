class User {
  final String name;
  final String gender;
  final DateTime birthDate;
  final String email;
  final String password;
  final String numeroUtente;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;

  User({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.password,
    required this.numeroUtente,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['user_id'] ?? 0,
    name: json['name'] ?? '',
    gender: json['gender'] ?? '',
    birthDate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : DateTime.now(),
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    numeroUtente: json['numeroutent']?.toString() ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
  );
}

}
