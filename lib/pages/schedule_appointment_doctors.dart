import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/pages/schedule_appointment.dart';

import 'package:onlinedoctorapp/services/user.dart';

import '../utils/snackbar_help.dart';

class ScheduleAppointmentDoctors extends StatefulWidget {
  static const String routeName = "/schedule-appointment";

  const ScheduleAppointmentDoctors({super.key});

  @override
  State<ScheduleAppointmentDoctors> createState() =>
      _ScheduleAppointmentDoctorsState();
}

class _ScheduleAppointmentDoctorsState
    extends State<ScheduleAppointmentDoctors> {
  List doctors = [];

  final formKey = GlobalKey<FormState>();

  final _specialty = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final response = await UserService.fetch();
    if (response != null) {
      setState(() {
        doctors = response;
      });
    } else {
      showErrorMessage(context, message: 'Nenhum médico encontrado!');
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
                              hintText: "Digite o nome do médico",
                              labelText: "Médico"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                        const Text(
                          "MÉDICOS",
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
              child: Visibility(
                visible: doctors.isNotEmpty,
                replacement: Center(
                  child: Text(
                    'Nenhum médico encontrado!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    var doctor = doctors[index];
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text(doctor['name']),
                            subtitle: Text(doctor['email'] ?? ''),
                            leading: CircleAvatar(
                                child: Image.asset('assets/no-picture.png')),
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'schedule') {
                                  scheduleAppointment(doctor);
                                } else if (value == 'view') {
                                } else {}
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'schedule',
                                    child: Text('Marcar Consulta'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'view',
                                    child: Text('Ver Perfil'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'mail',
                                    child: Text('Enviar Mensagem'),
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

  Future<void> scheduleAppointment(Map doctor) async {
    final route = MaterialPageRoute(
      builder: (context) => ScheduleAppointment(doctor: doctor, edit: false),
    );

    await Navigator.push(context, route);
  }
}
