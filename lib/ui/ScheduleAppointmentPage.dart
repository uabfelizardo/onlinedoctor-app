import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ConfirmAppointmentPage.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final String doctorName;

  ScheduleAppointmentPage({required this.doctorName});

  @override
  _ScheduleAppointmentPageState createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  List<String> specialities = ['Cardiology', 'Dermatology', 'Pediatrics'];
  String selectedSpeciality = 'Cardiology'; // Default selected specialty
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedDoctor = ''; // Variable to store selected doctor

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
    selectedDoctor = widget.doctorName; // Set selected doctor name

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
            Text(
              'Specialty:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: "Specialty",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.local_hospital),
              ),
              value: selectedSpeciality,
              items: specialities.map((String speciality) {
                return DropdownMenuItem(
                  value: speciality,
                  child: Text(speciality),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSpeciality = value.toString();
                });
              },
            ),
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
            Text(
              'Doctor:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: selectedDoctor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmAppointmentPage(
                      doctorName: selectedDoctor,
                      speciality: selectedSpeciality,
                      date: formattedDate,
                      time: formattedTime,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Continue'),
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
}
