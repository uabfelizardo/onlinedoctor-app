import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheduleAppointmentAvailability extends StatefulWidget {
  static const String routeName = "/schedule-appointment-doctor";

  @override
  State<ScheduleAppointmentAvailability> createState() =>
      _ScheduleAppointmentAvailabilityState();
}

class _ScheduleAppointmentAvailabilityState
    extends State<ScheduleAppointmentAvailability> {
  final formKey = GlobalKey<FormState>();

  final _specialty = TextEditingController();

  final _dateTime = TextEditingController();
  final _doctor = TextEditingController();

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
                        const Divider(
                          color: Colors.grey,
                          thickness: 5,
                          height: 20,
                        ),
                        const Text(
                          "HORÁRIOS DISPONÍVEIS",
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
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Row(
                        children: [
                          const Column(
                            children: [
                              Text("Horário"),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                              onPressed: () {},
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(0, 195, 255, 1),
                                ),
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text("Marcar")),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ]),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
