import 'dart:async';

class Specialities {
  static Future<List<String>> fetchSpecialities() async {
    // Simulated async call to fetch specialties from a database
    await Future.delayed(const Duration(seconds: 1));
    
    // Especialidades para testes
    List<String> specialities = [
      'Cardiologia',
      'Dermatologia',
      'Neurologia',
    ];

    return specialities;
  }
}
