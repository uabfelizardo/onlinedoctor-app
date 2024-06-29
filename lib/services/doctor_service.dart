import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedoctorapp/model/doctor.dart';
import 'package:onlinedoctorapp/model/review.dart';

class DoctorService {
  static const String baseUrl = 'http://localhost:5000';

  // static const String baseUrl = 'https://api-backend-p76c.onrender.com'; //Remote

  static Future<List<String>> geDoctorSpecialties() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/speciality'), // Substitua pela sua URL de API real
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> specialties =
            data.map((e) => e['description'] as String).toList();
        return specialties;
      } else {
        throw Exception('Failed to load user specialties');
      }
    } catch (error) {
      throw Exception('Failed to load user specialties: $error');
    }
  }

  static Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<Doctor> doctors = data.map((e) => Doctor.fromJson(e)).toList();
        return doctors;
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (error) {
      throw Exception('Failed to load doctors: $error');
    }
  }

  static Future<List<UserReview>> getDoctorReviews(int doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews/ByDoctor/$doctorId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<UserReview> reviews =  data.map((e) => UserReview.fromJson(e)).toList();
        return reviews;
      } else {
        throw Exception(
            'Failed to load doctor reviews: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load doctor reviews: $error');
    }
  }
}
