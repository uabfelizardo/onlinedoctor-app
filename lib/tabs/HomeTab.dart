import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/styles/colors.dart';
import 'package:onlinedoctorapp/styles/styles.dart';
import 'package:onlinedoctorapp/ui/auth/LoginPage.dart';
import '../services/UserService.dart';
import '../ui/DoctorDetailsPage.dart';
import '../ui/ScheduleAppointmentPage.dart';
import '../ui/UserRegistrationPage.dart';
import '../ui/DoctorRegistrationPage.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Doctor App 👋'),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('/onlinedoctor.png'),
              ),
              title: const Text('User details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRegistrationPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('/onlinedoctor.png'),
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
      body: HomeTab(
        onPressedScheduleCard: () {},
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final void Function() onPressedScheduleCard;

  const HomeTab({
    Key? key,
    required this.onPressedScheduleCard,
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
    fetchUsers();
    searchController.addListener(_filterDoctors);
  }

  Future<void> fetchUsers() async {
    try {
      final List<dynamic> fetchedDoctors = await UserService.getUsers();
      setState(() {
        doctors = fetchedDoctors;
        filteredDoctors = fetchedDoctors;
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        return doctor['name'].toLowerCase().contains(query);
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
                  color: Color(MyColors.header01),
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
                        return TopDoctorCard(
                          img: '/onlinedoctor.png',
                          doctorName: filteredDoctors[index]['name'],
                          doctorTitle:
                              filteredDoctors[index]['title'] ?? 'Specialist',
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
  }
}

class TopDoctorCard extends StatelessWidget {
  final String img;
  final String doctorName;
  final String doctorTitle;

  TopDoctorCard({
    required this.img,
    required this.doctorName,
    required this.doctorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          _showOptions(context, doctorName, doctorTitle);
        },
        child: Row(
          children: [
            Container(
              color: Color(MyColors.grey01),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(img),
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
                    color: Color(MyColors.header01),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  doctorTitle,
                  style: TextStyle(
                    color: Color(MyColors.grey02),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(MyColors.yellow02),
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '4.0 - 50 Reviews',
                      style: TextStyle(color: Color(MyColors.grey02)),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showOptions(
      BuildContext context, String doctorName, String doctorTitle) {
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
                  // Navegar para a página de chat com o médico
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
        color: Color(MyColors.bg),
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
              color: Color(MyColors.purple02),
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
                  color: Color(MyColors.purple01),
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
