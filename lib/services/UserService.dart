import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  // static const String baseUrl = 'http://localhost:5000/user'; //Local
  static const String baseUrl =
      'https://api-backend-p76c.onrender.com/user'; //Remote

  static Future<List<dynamic>> getUsers() async {
    try {
      final url = Uri.parse(baseUrl);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Se a resposta da API for bem-sucedida, decodifique os dados JSON
        final List<dynamic> users = jsonDecode(response.body);
        return users;
      } else {
        // Se a resposta da API não for bem-sucedida, lance uma exceção
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (error) {
      // Trate qualquer erro que ocorra durante a chamada da API
      print('Error during API call: $error');
      return []; // Retorne uma lista vazia em caso de erro
    }
  }
}
