import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/services/DoctorService.dart';
import 'ScheduleAppointmentPage.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String doctorName;
  final String doctorTitle;
  final String additionalInfo;

  DoctorDetailsPage({
    required this.doctorName,
    required this.doctorTitle,
    required this.additionalInfo,
  });

  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  late String firstName;
  late TextEditingController additionalInfoController;

  @override
  void initState() {
    super.initState();
    firstName = widget.doctorName; // Inicializa com o valor do prop doctorName
    additionalInfoController =
        TextEditingController(text: widget.additionalInfo);

    // Busca o ID do usuário ao iniciar e atualiza a informação adicional
    List<String> nameParts = firstName.split(' ');
    String middleName = nameParts.length > 2 ? nameParts[1] : '';
    getDoctorAdditionalInformationUserID(middleName);
  }

  Future<void> getDoctorAdditionalInformationUserID(String name) async {
    try {
      final userID = await DoctorService.getUserIdByDoctorName(name);

      if (userID == null) {
        throw Exception('User not found');
      } else {
        print("UserID : " + userID.toString());
        final fetchedAdditionalInfo =
            await DoctorService.getDoctorAdditionalInfoByUserId(userID);
        print('additional information = ' + fetchedAdditionalInfo.toString());

        // Atualiza o controlador com a nova informação adicional
        setState(() {
          additionalInfoController.text = fetchedAdditionalInfo!;
        });
      }
    } catch (e) {
      print('Failed to get user ID: $e');
    }
  }

  @override
  void dispose() {
    additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 60.0),
              const Text(
                "Doctor Information",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/person.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "First Name",
              prefixIcon: const Icon(Icons.person),
            ),
            initialValue: widget.doctorName,
            readOnly: true,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Last Name",
              prefixIcon: const Icon(Icons.person),
            ),
            initialValue: widget.doctorTitle,
            readOnly: true,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Additional Information",
              prefixIcon: const Icon(Icons.info),
            ),
            controller: additionalInfoController,
            readOnly: true,
            maxLines:
                null, // Permite que o campo de texto cresça conforme necessário
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  print("Clicked successfully to open Chat ...");
                },
                icon: Icon(Icons.chat),
                label: Text("Chat with Doctor"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  backgroundColor: Colors.blue,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleAppointmentPage(
                        doctorName: widget.doctorName,
                        userName: "userName",
                        specialty: '', // Passa o nome do paciente
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.calendar_today),
                label: Text("Schedule Appointment"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
