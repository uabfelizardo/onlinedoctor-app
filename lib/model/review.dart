import 'doctor.dart';
import 'user.dart';

class UserReview {
  final int id;
  final int userId;
  final int doctorInformationUserId;
  final String reviewText;
  final DateTime reviewDate;
  final int reviewRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Doctor doctor;
  final User user;

  UserReview({
    required this.id,
    required this.userId,
    required this.doctorInformationUserId,
    required this.reviewText,
    required this.reviewDate,
    required this.reviewRating,
    required this.createdAt,
    required this.updatedAt,
    required this.doctor,
    required this.user,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
  final doctorJson = json['doctor'] ?? {};
  final userJson = json['user'] ?? {};

  return UserReview(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    doctorInformationUserId: json['doctorInformation_userId'] ?? 0,
    reviewText: json['review_text'] ?? '',
    reviewDate: json['review_date'] != null ? DateTime.parse(json['review_date']) : DateTime.now(),
    reviewRating: json['review_rating'] ?? 0,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    doctor: Doctor.fromJson(doctorJson),
    user: User.fromJson(userJson),
  );
}
}