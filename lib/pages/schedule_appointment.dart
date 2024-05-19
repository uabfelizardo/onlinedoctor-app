import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleAppointment extends StatefulWidget {
  static const String routeName = "/schedule-appointment";

  const ScheduleAppointment({super.key});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  final formKey = GlobalKey<FormState>();

  final _specialty = TextEditingController();

  final _doctor = TextEditingController();

  final TextEditingController _dateTimeController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _dateTimeController.text = pickedDateTime.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("AGENDAR CONSULTA",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Form(
                key: formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _specialty,
                          keyboardType: TextInputType.emailAddress,
                          //validator: (s) {},
                          decoration: const InputDecoration(
                              hintText: "Digite a especialidade da consulta",
                              labelText: "Especialidade"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _dateTimeController,
                          keyboardType: TextInputType.text,
                          //validator: (s) {},
                          decoration: const InputDecoration(
                              hintText: "Digite a data e a hora da consulta",
                              labelText: "Data e Hora",
                              suffixIcon: Icon(Icons.calendar_today)),
                          onTap: () => _selectDateTime(context),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "MÉDICOS DA ESPECIALIDADE",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 195, 255, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.20,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: const Text("Nome do Médico"),
                        leading: Image.asset('assets/no-picture.png'),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
