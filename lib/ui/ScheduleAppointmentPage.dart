/* import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleAppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example list of specialties
    List<String> specialities = ['Cardiology', 'Dermatology', 'Pediatrics'];

    String selectedSpeciality = specialities[0]; // Default selected specialty
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
      if (pickedDate != null && pickedDate != selectedDate)
        selectedDate = pickedDate;
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedTime != null && pickedTime != selectedTime)
        selectedTime = pickedTime;
    }

    String formattedDate = DateFormat.yMMMd().format(selectedDate);
    String formattedTime = selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specialty:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField(
              value: selectedSpeciality,
              items: specialities.map((String speciality) {
                return DropdownMenuItem(
                  value: speciality,
                  child: Text(speciality),
                );
              }).toList(),
              onChanged: (value) {
                selectedSpeciality = value.toString();
                // Implement logic to select the specialty here
              },
            ),
            SizedBox(height: 20),
            Text(
              'Date:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Select Date: $formattedDate'),
            ),
            SizedBox(height: 20),
            Text(
              'Time:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Text('Select Time: $formattedTime'),
            ),
            SizedBox(height: 20),
            Text(
              'Doctor:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter doctor\'s name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                selectedDoctor = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement appointment scheduling logic here
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Continue'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */