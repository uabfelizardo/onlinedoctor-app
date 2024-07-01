import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/services/DoctorService.dart';
import 'package:onlinedoctorapp/services/UserService.dart';
import 'package:onlinedoctorapp/ui/SettingsPage.dart';
import 'package:onlinedoctorapp/ui/auth/LoginPage.dart';
import 'package:onlinedoctorapp/ui/DashboardPage.dart';
import '../ui/DoctorDetailsPage.dart';
import '../ui/ScheduleAppointmentPage.dart';
import '../ui/UserRegistrationPage.dart';
import '../ui/DoctorRegistrationPage.dart';
import '../tabs/ScheduleTab.dart';
import '../ui/ChatScreen.dart'; // Importe o arquivo ChatScreen.dart

class HomePage extends StatefulWidget {
  final Uint8List? imgBytes; // Use Uint8List? para aceitar nulos
  final String userName;
  final String userType;
  final String userID;
  final String specialty; // Adicionando o parâmetro specialty

  const HomePage({
    Key? key,
    this.imgBytes, // Permite que imgBytes seja nulo
    required this.userName,
    required this.userType,
    required this.userID,
    required this.specialty, // Adicionando o parâmetro specialty
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void goToSchedule() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  Future<void> getDoctorAdditionalInformationUserID(String name) async {
    try {
      final userID = await DoctorService.getUserIdByDoctorName(name);

      if (userID == null) {
        throw Exception('User not found');
      } else {
        print("UserID : " + userID.toString());
        final additionalInformation =
            await DoctorService.getDoctorAdditionalInfoByUserId(userID);
        print("Adicional do medico : " + additionalInformation.toString());
      }
    } catch (e) {
      print('Failed to get user ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map> navigationBarItems = [
      {'icon': Icons.local_hospital, 'index': 0},
      {'icon': Icons.calendar_today, 'index': 1},
    ];

    List<Widget> screens = [
      HomeTab(
        onPressedScheduleCard: goToSchedule,
        userType: widget.userType,
        userName: widget.userName,
      ),
      ScheduleTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Doctor App 👋'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.userName + "\n" + widget.userType,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: widget.imgBytes != null
                    ? MemoryImage(widget.imgBytes!)
                    : AssetImage(
                        '/person.png',
                      ) as ImageProvider, // Conversão explícita para ImageProvider
              ),
              title: const Text('User details'),
              onTap: () {
                Navigator.pop(context);
                if ((widget.userType == 'Patient') ||
                    (widget.userType == 'Admin')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserRegistrationPage(
                        userID: widget.userID.toString(),
                      ),
                    ),
                  );
                } else if (widget.userType == 'Doctor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorRegistrationPage(
                        userID: widget.userID.toString(),
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: widget.imgBytes != null
                    ? MemoryImage(widget.imgBytes!)
                    : AssetImage(
                        '/person.png',
                      ) as ImageProvider, // Conversão explícita para ImageProvider MemoryImage para exibir a imagem a partir dos bytes
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        selectedItemColor: Colors.purple,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          for (var navigationBarItem in navigationBarItems)
            BottomNavigationBarItem(
              icon: Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border(
                    top: _selectedIndex == navigationBarItem['index']
                        ? BorderSide(color: Colors.purple, width: 5)
                        : BorderSide.none,
                  ),
                ),
                child: Icon(
                  navigationBarItem['icon'],
                  color: _selectedIndex == navigationBarItem['index']
                      ? Colors.purple
                      : Colors.grey,
                ),
              ),
              label: '',
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final void Function() onPressedScheduleCard;
  final String userType;
  final String userName;

  const HomeTab({
    Key? key,
    required this.onPressedScheduleCard,
    required this.userType,
    required this.userName,
  }) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<dynamic> doctors;
  late List<dynamic> filteredDoctors;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    searchController.addListener(_filterDoctors);
  }

  Future<void> fetchDoctors() async {
    try {
      final List<dynamic> fetchedDoctors = await UserService.getAllDoctors();
      setState(() {
        doctors = fetchedDoctors
            .where((doctor) =>
                doctor['firstName'] != null && doctor['lastName'] != null)
            .toList();
        filteredDoctors = fetchedDoctors;
      });
    } catch (error) {
      print('Error fetching doctors: $error');
    }
  }

  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        String fullName = doctor['firstName'] + ' ' + doctor['lastName'];
        String speciality = doctor['speciality'];

        // Verifica se o nome do médico ou a especialidade contêm a consulta
        return fullName.toLowerCase().contains(query) ||
            (speciality.toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterDoctors);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userType == 'Patient') {
      return Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: [
                SizedBox(height: 20),
                SearchInput(controller: searchController),
                SizedBox(height: 20),
                Text(
                  'Top Doctor',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                filteredDoctors.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredDoctors.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Verifica se imgBytes é um Uint8List ou uma string e converte se necessário
                          Uint8List? imgBytes;
                          if (filteredDoctors[index]['img'] != null) {
                            if (filteredDoctors[index]['img'] is String) {
                              imgBytes =
                                  base64Decode(filteredDoctors[index]['img']);
                            } else if (filteredDoctors[index]['img']
                                is Uint8List) {
                              imgBytes = filteredDoctors[index]['img'];
                            }
                          }

                          return TopDoctorCard(
                            imgBytes: imgBytes ??
                                Uint8List(
                                    0), // Garante que imgBytes não seja nulo
                            doctorName: filteredDoctors[index]['prefix'] +
                                ' ' +
                                filteredDoctors[index]['firstName'] +
                                ' ' +
                                filteredDoctors[index]['lastName'],
                            doctorTitle: filteredDoctors[index]['speciality'] ??
                                'Specialist',
                            userName: widget.userName,
                            specialty: filteredDoctors[index]['speciality'],
                            userID: '',
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Se o usuário não for paciente, exibe o DashboardPage
      return DashboardPage();
    }
  }
}

class TopDoctorCard extends StatelessWidget {
  final Uint8List imgBytes;
  final String doctorName;
  final String doctorTitle;
  final String userName;
  final String specialty;
  final String userID; // Adicionando o userID

  TopDoctorCard({
    required this.imgBytes,
    required this.doctorName,
    required this.doctorTitle,
    required this.userName,
    required this.specialty,
    required this.userID, // Adicionando o userID
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          _showOptions(context, doctorName, doctorTitle, userName, userID);
        },
        child: Row(
          children: [
            Container(
              color: Colors.grey[200],
              child: CircleAvatar(
                radius: 25,
                backgroundImage: imgBytes.isNotEmpty
                    ? MemoryImage(imgBytes)
                    : AssetImage('assets/person.png') as ImageProvider,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  doctorTitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, String doctorName, String doctorTitle,
      String userName, String userID) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Doctor information'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsPage(
                        doctorName: doctorName,
                        doctorTitle: doctorTitle,
                        additionalInfo: 'Additional information goes here.',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Schedule appointment'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleAppointmentPage(
                        doctorName: doctorName,
                        userName: userName, // Passa o nome do paciente
                        specialty: specialty, // Passa a especialidade do médico
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chat with doctor'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        doctorName: doctorName,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController controller;

  const SearchInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Colors.purple,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search a doctor or health issue',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.purple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
