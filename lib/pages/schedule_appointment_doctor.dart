import 'package:flutter/material.dart';

class ScheduleAppointmentDoctor extends StatefulWidget {
  static const String routeName = "/schedule-appointment-doctor";

  const ScheduleAppointmentDoctor({super.key});

  @override
  State<ScheduleAppointmentDoctor> createState() =>
      _ScheduleAppointmentDoctorState();
}

class _ScheduleAppointmentDoctorState extends State<ScheduleAppointmentDoctor> {
  final formKey = GlobalKey<FormState>();

  // ignore: unused_field
  final _specialty = TextEditingController();

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
                        Row(
                          children: [
                            Image.asset(
                              "assets/no-picture.png",
                              width: 100,
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nome"),
                                  Text("Nome do Médico",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 15),
                                  Text("Especialidade"),
                                  Text("Especialidade da consulta",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(0, 195, 255, 1),
                            ),
                          ),
                          child: const Text("Consultar Disponibilidade"),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          color: Colors.grey,
                          thickness: 5,
                          height: 20,
                        ),
                        const Text(
                          "AVALIAÇÕES",
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
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: const Row(
                          children: [
                            Column(
                              children: [
                                Text("Pontuação"),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Data e Hora"),
                              ],
                            ),
                          ],
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome do Usuário"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Texto da avaliação..."),
                          ],
                        ),
                        leading: Image.asset('assets/no-picture.png'),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
