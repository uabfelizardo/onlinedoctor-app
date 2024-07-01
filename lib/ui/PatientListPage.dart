import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onlinedoctorapp/services/UserService.dart';

class PatientListPage extends StatefulWidget {
  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  late Future<List<dynamic>?> _futureDoctors;
  List<bool> doctorStatus = [];

  @override
  void initState() {
    super.initState();
    _futureDoctors = fetchDoctors();
  }

  Future<List<dynamic>?> fetchDoctors() async {
    try {
      final response = await http.get(
          Uri.parse('https://api-backend-p76c.onrender.com/userAllPatients'));
      if (response.statusCode == 200) {
        List<dynamic> doctors = jsonDecode(response.body);
        doctorStatus = List.generate(doctors.length, (index) => true);
        return doctors;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  Future<void> toggleDoctorStatus(int index) async {
    try {
      List<dynamic>? doctors = await _futureDoctors;
      if (doctors != null && index < doctors.length) {
        setState(() {
          doctorStatus[index] = !doctorStatus[index];
        });

        int doctorId = doctors[index]['id'];
        String newState = doctorStatus[index] ? 'Enabled' : 'Disabled';

        await UserService.updateUserState(doctorId, newState);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newState == 'Enabled' ? 'Enabled' : 'Disabled'),
          ),
        );
      } else {
        throw Exception('Doctor not found or index out of bounds');
      }
    } catch (e) {
      print('Erro ao atualizar o status do médico: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Erro ao atualizar o status do médico. Tente novamente.'),
        ),
      );
      // Reverta o estado local se a atualização falhar
      setState(() {
        doctorStatus[index] = !doctorStatus[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No doctors found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> doctor = snapshot.data![index];
                String firstName = doctor['firstName'] ?? 'No Name';
                String lastName = doctor['lastName'] ?? '';
                String fullName = '$firstName $lastName';
                String specialty = doctor['speciality'] ?? 'No Specialty';
                String gender = doctor['gender'] ?? 'No Gender';
                String birthdate = doctor['birthdate'] ?? 'No Birthdate';
                String contact = doctor['contact'] ?? 'No Contact';
                String email = doctor['email'] ?? 'No Email';

                return ListTile(
                  title: Text(fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Specialty: $specialty'),
                      Text('Gender: $gender'),
                      Text('Birthdate: $birthdate'),
                      Text('Contact: $contact'),
                      Text('Email: $email'),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/person.png'),
                  ),
                  tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                  trailing: IconButton(
                    icon: Icon(
                      doctorStatus[index]
                          ? Icons.check_circle_outline
                          : Icons.remove_circle_outline,
                      color: doctorStatus[index] ? Colors.green : Colors.red,
                    ),
                    onPressed: () {
                      toggleDoctorStatus(index);
                    },
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DoctorAvailabilityPage(
                    //       doctorName: fullName,
                    //       specialty: specialty,
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
