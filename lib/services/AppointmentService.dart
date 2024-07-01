import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  // static const String baseUrl = 'http://localhost:5000'; //Local
  static const String baseUrl =
      'https://api-backend-p76c.onrender.com'; //Remote

  Future<List<Appointment>> getAllAppointments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/appointment'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Appointment> appointments = data
            .map((appointment) => Appointment.fromJson(appointment))
            .toList();
        return appointments;
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  Future<Appointment> getAppointmentById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/appointment/$id'));
      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load appointment');
      }
    } catch (e) {
      throw Exception('Failed to load appointment: $e');
    }
  }

  Future<Appointment> addAppointment(Appointment appointment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appointment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(appointment.toJson()),
      );
      if (response.statusCode == 201) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add appointment');
      }
    } catch (e) {
      throw Exception('Failed to add appointment: $e');
    }
  }

  Future<Appointment> updateAppointment(int id, Appointment appointment) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/appointment/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(appointment.toJson()),
      );
      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update appointment');
      }
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/appointment/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete appointment');
      }
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }
}

class Appointment {
  final int id;
  final DateTime date;
  final String time;
  final String observation;
  final int patientId;
  final int doctorId;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.observation,
    required this.patientId,
    required this.doctorId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      observation: json['observation'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'time': time,
      'observation': observation,
      'patient_id': patientId,
      'doctor_id': doctorId,
    };
  }
}
