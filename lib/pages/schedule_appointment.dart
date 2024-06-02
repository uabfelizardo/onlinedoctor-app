import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/pages/appointments.dart';
import 'package:onlinedoctorapp/services/appointment.dart';
import 'package:onlinedoctorapp/utils/snackbar_help.dart';

class ScheduleAppointment extends StatefulWidget {
  final Map? doctor;
  final bool? edit;
  const ScheduleAppointment({super.key, this.doctor, this.edit});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  bool isEdit = false;

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
        startDateController.text = pickedDateTime.toString();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final doctor = widget.doctor;
    final userId = doctor!['id'];
    final name = doctor['name'] ?? '';
    final speciality = doctor['speciality'] ?? '';

    userIdController.text = userId.toString();
    nameController.text = name;
    specialityController.text = speciality;

    isEdit = (widget.edit == true) ? true : false;
    if (isEdit) {
      final startDate = doctor['startDate'] ?? '';
      final observation = doctor['observation'] ?? '';

      startDateController.text = startDate;
      observationController.text = observation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'EDITAR CONSULTA' : 'AGENDAR CONSULTA',
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      labelText: "Nome do Médico",
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder
                                          .none, // Remove a borda para parecer mais com um texto
                                    ),
                                  ),
                                  TextFormField(
                                    controller: specialityController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      labelText: "Especialidade",
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder
                                          .none, // Remove a borda para parecer mais com um texto
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: startDateController,
                          keyboardType: TextInputType.text,
                          //validator: (s) {},
                          decoration: const InputDecoration(
                              hintText: "Digite a data e a hora da consulta",
                              labelText: "Data e Hora",
                              suffixIcon: Icon(Icons.calendar_today)),
                          onTap: () => _selectDateTime(context),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: observationController,
                          decoration: const InputDecoration(
                              hintText:
                                  'Digite aqui informações relevantes para a consulta',
                              labelText: 'Observação'),
                          minLines: 5,
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                            onPressed: isEdit ? update : add,
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(0, 195, 255, 1),
                              ),
                            ),
                            icon: const Icon(Icons.check),
                            label: Text(
                              isEdit ? 'Editar Consulta' : 'Agendar Consulta',
                            )),
                        // const Divider(
                        //   color: Colors.grey,
                        //   thickness: 5,
                        //   height: 20,
                        // ),
                        // const Text(
                        //   "HORÁRIOS DISPONÍVEIS",
                        //   style: TextStyle(
                        //       color: Color.fromRGBO(0, 195, 255, 1),
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: MediaQuery.of(context).size.height * 0.20,
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   child: ListView.builder(
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Column(children: [
            //           Row(
            //             children: [
            //               const Column(
            //                 children: [
            //                   Text("Horário"),
            //                 ],
            //               ),
            //               const Spacer(),
            //               ElevatedButton.icon(
            //                   onPressed: () {},
            //                   style: ButtonStyle(
            //                     foregroundColor:
            //                         MaterialStateProperty.all<Color>(
            //                             Colors.white),
            //                     backgroundColor:
            //                         MaterialStateProperty.all<Color>(
            //                       const Color.fromRGBO(0, 195, 255, 1),
            //                     ),
            //                   ),
            //                   icon: const Icon(Icons.check),
            //                   label: const Text("Marcar")),
            //             ],
            //           ),
            //           const SizedBox(height: 20),
            //           const Divider(
            //             color: Colors.grey,
            //             thickness: 1,
            //           ),
            //         ]),
            //       );
            //     },
            //   ),
            // ),
          ],
        ));
  }

  Future<void> add() async {
    final isSuccess = await AppointmentService.add(body);

    if (isSuccess) {
      showSuccessMessage(context, message: 'Consulta agendada com sucesso!');
      final route = MaterialPageRoute(
        builder: (context) => const Appointments(),
      );

      await Navigator.push(context, route);
    } else {
      showErrorMessage(context, message: 'Erro ao agendar a consulta!');
    }
  }

  Future<void> update() async {
    final doctor = widget.doctor;
    if (doctor == null) {
      return;
    }
    final id = doctor['id'];

    final isSuccess = await AppointmentService.update(id, body);

    if (isSuccess) {
      final route = MaterialPageRoute(
        builder: (context) => const Appointments(),
      );

      await Navigator.push(context, route);
      showSuccessMessage(context, message: 'Consulta editada com sucesso!');
    } else {
      showErrorMessage(context, message: 'Erro ao editar a consulta!');
    }
  }

  Map get body {
    //Get the data from form
    final userId = int.parse(userIdController.text);
    final startDate = startDateController.text;
    final observation = observationController.text;
    return {
      "user_id": userId,
      "startDate": startDate,
      "observation": observation,
    };
  }
}
