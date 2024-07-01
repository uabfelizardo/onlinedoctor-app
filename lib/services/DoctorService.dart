import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorService {
  // static const String baseUrl = 'http://localhost:5000'; //local
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

  // Método para buscar o specialityId pela descrição
  static Future<int?> getSpecialityIdByDescription(String description) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/speciality/description/$description'), // Endpoint ajustado
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> specialities = jsonDecode(response.body);
        if (specialities.isNotEmpty) {
          return specialities[0]['id']; // Supondo que o campo de ID é 'id'
        }
        return null;
      } else {
        throw Exception('Failed to load specialities');
      }
    } catch (error) {
      throw Exception('Failed to load specialities: $error');
    }
  }

  // Método para adicionar uma nova combinação entre médico e especialidade
  static Future<Map<String, dynamic>?> addDoctorSpeciality(
      Map<String, dynamic> specialityData) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/doctorspeciality'), // Substitua pela URL correta do seu endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(specialityData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to add doctor speciality');
      }
    } catch (error) {
      throw Exception('Failed to add doctor speciality: $error');
    }
  }

  // Método para adicionar informação adicional do médico
  static Future<Map<String, dynamic>?> addDoctorInformation(
      Map<String, dynamic> doctorInformationData) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/doctorinformation'), // Substitua pela URL correta do seu endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(doctorInformationData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to add doctor information');
      }
    } catch (error) {
      throw Exception('Failed to add doctor information: $error');
    }
  }

  static Future<List<String>> getDoctorSpecialities(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctorspecialities/user/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> doctorSpecialitiesJson = jsonDecode(response.body);

        // Lista para armazenar as descrições das especialidades
        List<String> doctorSpecialities = [];

        // Iterar sobre as associações médico-especialidade
        for (var item in doctorSpecialitiesJson) {
          // Obter o speciality_id
          final specialityId = item['speciality_id'];

          // Buscar a descrição da especialidade usando o speciality_id
          final specialityDescription =
              await getSpecialityDescription(specialityId);

          // Adicionar a descrição da especialidade à lista
          doctorSpecialities.add(specialityDescription);
        }

        return doctorSpecialities;
      } else {
        throw Exception('Failed to load doctor specialities');
      }
    } catch (error) {
      throw Exception('Failed to load doctor specialities: $error');
    }
  }

  static Future<String> getSpecialityDescription(int specialityId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/speciality/$specialityId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> specialityJson = jsonDecode(response.body);
        final specialityDescription = specialityJson['description'];
        return specialityDescription;
      } else {
        throw Exception('Failed to load speciality description');
      }
    } catch (error) {
      throw Exception('Failed to load speciality description: $error');
    }
  }

  // Método para buscar o ID do usuário (médico) pelo nome
  static Future<String?> getUserIdByDoctorName(String firstName) async {
    final response = await http.get(
      Uri.parse(
          'https://api-backend-p76c.onrender.com/user/firstName/$firstName'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('userId')) {
        return data['userId'].toString();
      } else {
        throw Exception('User ID not found in response');
      }
    } else {
      throw Exception('Failed to load user ID');
    }
  }

  // Função para buscar informações adicionais do médico pelo userID
  static Future<String?> getDoctorAdditionalInfoByUserId(String userID) async {
    final response = await http.get(
      Uri.parse(
          'https://api-backend-p76c.onrender.com/user/$userID/doctorinformation'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> &&
          data.containsKey('additionalInformation')) {
        return data['additionalInformation'].toString();
      } else {
        throw Exception('Additional Information not found in response');
      }
    } else {
      throw Exception('Failed to load doctor information');
    }
  }

  Future<int?> getDoctorUserIdByName(String doctorName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/firstName/$doctorName'),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return data[
            'userId']; // Verifique se está retornando o campo correto (userId)
      } else {
        throw Exception('Failed to fetch doctor ID');
      }
    } catch (error) {
      throw Exception('Failed to fetch doctor ID: $error');
    }
  }

  Future<int?> getPatientIdByFirstName(String patientName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/firstNamePaient/$patientName'),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return data[
            'userId']; // Verifique se está retornando o campo correto (userId)
      } else {
        throw Exception('Failed to fetch doctor ID');
      }
    } catch (error) {
      throw Exception('Failed to fetch doctor ID: $error');
    }
  }
}
