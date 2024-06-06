import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'AppointmentDetailsPage.dart';

class ConfirmAppointmentPage extends StatelessWidget {
  final String doctorName;
  final String speciality;
  final String date;
  final String time;

  ConfirmAppointmentPage({
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Appointment'),
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
              'Doctor:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                    '/onlinedoctor.png'), // Add the doctor's photo here
              ),
              title: Text(doctorName),
              subtitle: Text(speciality),
            ),
            SizedBox(height: 20),
            Text(
              'Date:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(date),
            SizedBox(height: 20),
            Text(
              'Time:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(time),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Abra o explorador de arquivos para selecionar o documento
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  // O arquivo foi selecionado
                  // Faça algo com o arquivo selecionado, como salvá-lo ou enviá-lo para o servidor
                }
              },
              child: Text('Upload Documents'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 10), // Adiciona um pequeno espaço entre os botões
            ElevatedButton(
              onPressed: () {
                // Navegar para a página AppointmentDetailsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetailsPage(
                      speciality: speciality,
                      date: date,
                      time: time,
                      doctorName: doctorName,
                    ),
                  ),
                );
              },
              child: Text('Schedule Appointment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
