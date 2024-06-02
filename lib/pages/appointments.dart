import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onlinedoctorapp/pages/schedule_appointment.dart';
import 'package:onlinedoctorapp/pages/schedule_appointment_doctors.dart';
import 'package:onlinedoctorapp/services/appointment.dart';

import '../utils/snackbar_help.dart';

class Appointments extends StatefulWidget {
  static const String routeName = "/schedule-appointment";

  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  List appointments = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final response = await AppointmentService.fetch();
    if (response != null) {
      setState(() {
        appointments = response;
      });
    } else {
      showErrorMessage(context, message: 'Nenhuma consulta encontrada!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("CONSULTAS",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: scheduleAppointmentDoctors,
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(0, 195, 255, 1),
                    ),
                  ),
                  child: const Text("Nova Consulta")),
            ),
            Expanded(
              child: Visibility(
                visible: appointments.isNotEmpty,
                replacement: Center(
                  child: Text(
                    'Nenhuma consulta encontrada!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                child: ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text(appointment['startDate']),
                            subtitle: Text(appointment['observation']),
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'view') {
                                  edit(appointment);
                                } else {
                                  cancel(appointment['id']);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'view',
                                    child: Text('Ver/Editar'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Cancelar'),
                                  )
                                ];
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> scheduleAppointmentDoctors() async {
    final route = MaterialPageRoute(
      builder: (context) => const ScheduleAppointmentDoctors(),
    );

    await Navigator.push(context, route);
  }

  Future<void> edit(Map doctor) async {
    final route = MaterialPageRoute(
      builder: (context) => ScheduleAppointment(doctor: doctor, edit: true),
    );

    await Navigator.push(context, route);
  }

  Future<void> cancel(int id) async {
    final isSuccess = await AppointmentService.deleteById(id);
    if (isSuccess) {
      final filtered =
          appointments.where((element) => element['id'] != id).toList();
      setState(() {
        appointments = filtered;
      });
      showSuccessMessage(context, message: 'Consulta cancelada com sucesso!');
    } else {
      showErrorMessage(context, message: 'Erro ao cancelar!');
    }
  }
}
