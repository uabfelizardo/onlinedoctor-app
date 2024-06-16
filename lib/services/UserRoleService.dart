import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRoleService {
  // static const String baseUrl = 'http://localhost:5000';
  static const String baseUrl =
      'https://api-backend-p76c.onrender.com'; //Remote
  static Future<List<String>> getUserRoles() async {
    final response = await http.get(Uri.parse('$baseUrl/role'));

    if (response.statusCode == 200) {
      final List<dynamic> rolesJson = jsonDecode(response.body);
      // return rolesJson.map((role) => role.toString()).toList();
      return rolesJson.map((role) => role['description'].toString()).toList();
    } else {
      throw Exception('Failed to load user roles');
    }
  }

  Future<int> getRoleIdByDescription(String description) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/role?description=$description'),
      );

      if (response.statusCode == 200) {
        final roleId = jsonDecode(response.body)['id'];
        return roleId;
      } else {
        throw Exception('Failed to get role ID by description');
      }
    } catch (error) {
      throw Exception('Failed to get role ID by description: $error');
    }
  }

  Future<Map<String, dynamic>?> addUserRole(
      Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/userrole'), // Substitua pela URL correta do seu endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to add user role');
      }
    } catch (error) {
      throw Exception('Failed to add user role: $error');
    }
  }
}
