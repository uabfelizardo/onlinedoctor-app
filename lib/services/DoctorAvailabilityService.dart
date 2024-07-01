import 'package:http/http.dart' as http;

class DoctorAvailabilityService {
  // static const String baseUrl = 'http://localhost:5000'; //Local

  static const String baseUrl =
      'https://api-backend-p76c.onrender.com'; //Remote

  Future<bool> addDoctorAvailability({
    required int doctorId,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required bool sunday,
    required String startTime,
    required String endTime,
  }) async {
    var url = Uri.parse('$baseUrl/availability');
    var response = await http.post(
      url,
      body: {
        'doctor_id': doctorId.toString(),
        'monday': monday ? '1' : '0',
        'tuesday': tuesday ? '1' : '0',
        'wednesday': wednesday ? '1' : '0',
        'thursday': thursday ? '1' : '0',
        'friday': friday ? '1' : '0',
        'saturday': saturday ? '1' : '0',
        'sunday': sunday ? '1' : '0',
        'startTime': startTime,
        'endTime': endTime,
      },
    );

    if (response.statusCode == 201) {
      return true; // Sucesso ao adicionar disponibilidade
    } else {
      throw Exception('Failed to add doctor availability');
    }
  }

  Future<bool> updateDoctorAvailability({
    required int availabilityId,
    required int doctorId,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required bool sunday,
    required String startTime,
    required String endTime,
  }) async {
    var url = Uri.parse('$baseUrl/availability/$availabilityId');
    var response = await http.put(
      url,
      body: {
        'doctor_id': doctorId.toString(),
        'monday': monday ? '1' : '0',
        'tuesday': tuesday ? '1' : '0',
        'wednesday': wednesday ? '1' : '0',
        'thursday': thursday ? '1' : '0',
        'friday': friday ? '1' : '0',
        'saturday': saturday ? '1' : '0',
        'sunday': sunday ? '1' : '0',
        'startTime': startTime,
        'endTime': endTime,
      },
    );

    if (response.statusCode == 200) {
      return true; // Sucesso ao atualizar disponibilidade
    } else {
      throw Exception('Failed to update doctor availability');
    }
  }
}
