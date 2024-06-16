import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorService {
  // static const String baseUrl = 'http://localhost:5000';
  static const String baseUrl =
      'https://api-backend-p76c.onrender.com'; //Remote
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
}
