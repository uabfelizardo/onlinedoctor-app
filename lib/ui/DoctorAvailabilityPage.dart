import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onlinedoctorapp/services/DoctorAvailabilityService.dart';
import 'package:onlinedoctorapp/services/DoctorService.dart';

class DoctorAvailabilityPage extends StatefulWidget {
  final String doctorName;
  final String specialty;

  DoctorAvailabilityPage({
    required this.doctorName,
    required this.specialty,
  });

  @override
  _DoctorAvailabilityPageState createState() => _DoctorAvailabilityPageState();
}

class _DoctorAvailabilityPageState extends State<DoctorAvailabilityPage> {
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _saveAvailability() async {
    try {
      // List<String> nameParts = widget.doctorName.split(' ');
      // String middleName = nameParts.length > 2 ? nameParts[1] : '';

      final doctorService = DoctorService();
      final doctorId =
          await doctorService.getDoctorUserIdByName(widget.doctorName);

      print('Nome do medico: ' + widget.doctorName);
      print('Doctor id: ' + doctorId.toString());

      if (doctorId == null) {
        throw Exception('Doctor ID not found for name: ${widget.doctorName}');
      }

      // Salva a disponibilidade utilizando o ID encontrado

      await DoctorAvailabilityService().addDoctorAvailability(
        doctorId: doctorId, // You should replace this with the actual doctor ID
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor availability successfully recorded!'),
          duration: Duration(seconds: 2),
        ),
      );
      // Optionally navigate to another page here after success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to record availability. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  Widget _buildDayCheckbox(
      String day, bool value, void Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(day),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectTime(context, controller),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Availability'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                      'Doctor: ${widget.doctorName}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Specialty: ${widget.specialty}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Days of the Week:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildDayCheckbox('Monday', monday, (value) {
              setState(() {
                monday = value!;
              });
            }),
            _buildDayCheckbox('Tuesday', tuesday, (value) {
              setState(() {
                tuesday = value!;
              });
            }),
            _buildDayCheckbox('Wednesday', wednesday, (value) {
              setState(() {
                wednesday = value!;
              });
            }),
            _buildDayCheckbox('Thursday', thursday, (value) {
              setState(() {
                thursday = value!;
              });
            }),
            _buildDayCheckbox('Friday', friday, (value) {
              setState(() {
                friday = value!;
              });
            }),
            _buildDayCheckbox('Saturday', saturday, (value) {
              setState(() {
                saturday = value!;
              });
            }),
            _buildDayCheckbox('Sunday', sunday, (value) {
              setState(() {
                sunday = value!;
              });
            }),
            SizedBox(height: 20),
            Text(
              'Time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Row(
              children: [
                _buildTimeField('Start Time', _startTimeController),
                SizedBox(width: 10),
                _buildTimeField('End Time', _endTimeController),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAvailability,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 0),
                backgroundColor: Colors.purple,
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Cor branca para o texto
                ),
              ),
              child: Text('Save Availability'),
            )
          ],
        ),
      ),
    );
  }
}
