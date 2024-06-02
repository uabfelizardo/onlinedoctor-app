import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  static Future<List?> fetch() async {
    const url = 'http://localhost:5000/user';
    final uri = Uri.parse(url); //Later join to the next line
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      return null;
    }
  }

  static Future<bool> add(Map body) async {
    const url = 'https://localhost:5000/user';
    final uri = Uri.parse(url); //Later join to the next line
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 201;
  }

  static Future<Map<String, dynamic>?> findById(String id) async {
    final url = 'https://localhost:5000/user/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> update(String id, Map body) async {
    final url = 'https://localhost:5000/user/$id';
    final uri = Uri.parse(url); //Later join to the next line
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url); //Later join to the next line
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}
