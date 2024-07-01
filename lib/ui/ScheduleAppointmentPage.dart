import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ConfirmAppointmentPage.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final String doctorName;
  final String userName;
  final String specialty;

  ScheduleAppointmentPage({
    required this.doctorName,
    required this.userName,
    required this.specialty,
  });

  @override
  _ScheduleAppointmentPageState createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController observationController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMd().format(selectedDate);
    String formattedTime = selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
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
            _buildInfoCard('Specialty', widget.specialty),
            SizedBox(height: 20),
            _buildDateTimeField(
              context: context,
              controller: TextEditingController(text: formattedDate),
              hintText: "Date",
              icon: Icons.calendar_today,
              onTap: () {
                _selectDate(context);
              },
            ),
            SizedBox(height: 20),
            _buildDateTimeField(
              context: context,
              controller: TextEditingController(text: formattedTime),
              hintText: "Time",
              icon: Icons.access_time,
              onTap: () {
                _selectTime(context);
              },
            ),
            SizedBox(height: 20),
            _buildInfoCard('Doctor', widget.doctorName),
            SizedBox(height: 20),
            _buildInfoCard('Patient', widget.userName),
            SizedBox(height: 20),
            _buildObservationField(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmAppointmentPage(
                      doctorName: widget.doctorName,
                      speciality: widget.specialty,
                      date: formattedDate,
                      time: formattedTime,
                      userName: widget.userName,
                      observation: observationController.text,
                      appointmentId: 123,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white, // Cor branca para o texto
                      fontSize:
                          16, // Tamanho da fonte (ajuste conforme necessário)
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required void Function() onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.purple.withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }

  Widget _buildInfoCard(String title, String info) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              info,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationField() {
    return TextFormField(
      controller: observationController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Observations',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.purple.withOpacity(0.1),
        filled: true,
      ),
    );
  }
}
