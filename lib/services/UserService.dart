import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  // static const String baseUrl = 'http://localhost:5000/user'; //Local

  static String baseUrl = 'https://api-backend-p76c.onrender.com/user'; //Remote

  static Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  Future<dynamic> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to load user');
      }
    } catch (error) {
      throw Exception('Failed to load user: $error');
    }
  }

  Future<dynamic> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add user');
      }
    } catch (error) {
      throw Exception('Failed to add user: $error');
    }
  }

  Future<dynamic> updateUser(int id, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      throw Exception('Failed to update user: $error');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      throw Exception('Failed to delete user: $error');
    }
  }
}
