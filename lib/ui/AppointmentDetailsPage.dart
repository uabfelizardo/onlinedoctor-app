import 'package:flutter/material.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final String speciality;
  final String date;
  final String time;
  final String doctorName;

  AppointmentDetailsPage({
    required this.speciality,
    required this.date,
    required this.time,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Especialidade: $speciality',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Data: $date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Hora: $time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Médico: $doctorName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Dados Paciente',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/doctor.jpg'),
              ),
              title: Text('Dr. $doctorName'),
              subtitle: Text('Médico'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/patient.jpg'),
              ),
              title: Text('Frandle'),
              subtitle: Text('Paciente'),
            ),
            SizedBox(height: 20),
            Text(
              'Documentos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Aqui você pode adicionar a seção de documentos anexos
          ],
        ),
      ),
    );
  }
}
