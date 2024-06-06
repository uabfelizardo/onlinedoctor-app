import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  // static const String baseUrl = 'http://localhost:5000'; //Local
  static const String baseUrl =
      'https://api-backend-p76c.onrender.com'; //Remote

  static Future<Map<String, dynamic>?> checkUser(
      String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');

      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print("Request sent with email: $email");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData; // Retorne os dados do usuário
      } else if (response.statusCode == 401) {
        return null; // Indique falha na autenticação
      } else {
        throw Exception('Failed to authenticate user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during API call: $error');
      return null;
    }
  }
}
