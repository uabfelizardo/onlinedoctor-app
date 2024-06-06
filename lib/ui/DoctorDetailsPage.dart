import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ScheduleAppointmentPage.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String doctorName;
  final String doctorTitle;
  final String additionalInfo;

  DoctorDetailsPage({
    required this.doctorName,
    required this.doctorTitle,
    required this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Doctor information",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          '/onlinedoctor.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "First Name",
                        prefixIcon: const Icon(Icons.person),
                      ),
                      initialValue: doctorName,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        prefixIcon: const Icon(Icons.person),
                      ),
                      initialValue: doctorTitle,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Additional Information",
                        prefixIcon: const Icon(Icons.info),
                      ),
                      initialValue: additionalInfo,
                      readOnly: true,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Lógica para iniciar o chat com o médico
                      },
                      icon: Icon(Icons.chat),
                      label: Text("Chat with Doctor"),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleAppointmentPage(
                              doctorName: doctorName,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text("Schedule Appointment"),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DoctorDetailsPage(
      doctorName: 'Dr. Ornelo',
      doctorTitle: 'Heart Specialist',
      additionalInfo: 'Additional information goes here...',
    ),
  ));
}