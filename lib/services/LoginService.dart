/* import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl =
      'http://localhost:5000'; // Altere para a URL da sua API

  static Future<bool> checkUser(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');

      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      print("object " + email.toString());

      if (response.statusCode == 200) {
        // Se a resposta da API for bem-sucedida, verifique se o usuário foi encontrado
        final responseData = jsonDecode(response.body);
        final bool userFound = responseData['userFound'];
        return userFound;
      } else {
        // Se a resposta da API não for bem-sucedida, lance uma exceção
        throw Exception('Failed to authenticate user: ${response.statusCode}');
      }
    } catch (error) {
      // Trate qualquer erro que ocorra durante a chamada da API
      print('Error during API call: $error');
      return false; // Retorne false em caso de erro
    }
  }
} */
