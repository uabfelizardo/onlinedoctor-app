import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentListPage extends StatefulWidget {
  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  late Future<List<Map<String, dynamic>>?> _futureAppointments;

  @override
  void initState() {
    super.initState();
    _futureAppointments = fetchAppointments();
  }

  Future<List<Map<String, dynamic>>?> fetchAppointments() async {
    try {
      final response = await http
          .get(Uri.parse('https://api-backend-p76c.onrender.com/appointment'));
      if (response.statusCode == 200) {
        List<dynamic> appointments = jsonDecode(response.body);
        List<Map<String, dynamic>> updatedAppointments = [];

        for (var appointment in appointments) {
          String doctorName = await fetchUserName(appointment['doctor_id']);
          String patientName = await fetchUserName(appointment['patient_id']);

          appointment['doctorName'] = doctorName;
          appointment['patientName'] = patientName;
          updatedAppointments.add(appointment);
        }

        return updatedAppointments;
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load appointments: $error');
    }
  }

  Future<String> fetchUserName(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('https://api-backend-p76c.onrender.com/user/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> user = jsonDecode(response.body);
        String firstName = user['firstName'];
        String lastName = user['lastName'];
        return '$firstName $lastName';
      } else {
        throw Exception('Failed to load user $userId: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user $userId: $error');
    }
  }

  Future<void> toggleAppointmentApproval(
      int appointmentId, bool currentStatus) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://api-backend-p76c.onrender.com/appointment/$appointmentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'approved': !currentStatus}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _futureAppointments = fetchAppointments();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Appointment ${!currentStatus ? 'approved' : 'disapproved'} successfully')),
        );
      } else {
        throw Exception(
            'Failed to update appointment status: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating appointment status: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment List'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointments found.'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> appointment = snapshot.data![index];
                String doctorName = appointment['doctorName'];
                String patientName = appointment['patientName'];
                String date = appointment['date'];
                String time = appointment['time'];
                String observation =
                    appointment['observation'] ?? 'No Observation';
                bool approved = appointment['approved'] ?? false;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Doctor Name: $doctorName',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Patient Name: $patientName',
                            style: TextStyle(fontSize: 16)),
                        Text('Date: $date', style: TextStyle(fontSize: 16)),
                        Text('Time: $time', style: TextStyle(fontSize: 16)),
                        Text('Observation: $observation',
                            style: TextStyle(fontSize: 16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                approved
                                    ? Icons.check_circle
                                    : Icons.remove_circle,
                                color: approved ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                toggleAppointmentApproval(
                                    appointment['id'], approved);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AppointmentListPage(),
  ));
}
