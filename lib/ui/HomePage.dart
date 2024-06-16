import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/styles/colors.dart';
import 'package:onlinedoctorapp/styles/styles.dart';
import 'package:onlinedoctorapp/ui/auth/LoginPage.dart';
import '../services/UserService.dart';
import '../ui/DoctorDetailsPage.dart';
import '../ui/ScheduleAppointmentPage.dart';
import '../ui/UserRegistrationPage.dart';
import '../ui/DoctorRegistrationPage.dart';
import '../tabs/ScheduleTab.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final String userType;

  const HomePage({Key? key, required this.userName, required this.userType})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    List<Map> navigationBarItems = [
      {'icon': Icons.local_hospital, 'index': 0},
      {'icon': Icons.calendar_today, 'index': 1},
    ];

    List<Widget> screens = [
      HomeTab(
        onPressedScheduleCard: goToSchedule,
      ),
      ScheduleTab(),
    ];

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
                backgroundImage: AssetImage('/onlinedoctor.png'),
              ),
              title: const Text('User details'),
              onTap: () {
                Navigator.pop(context);
                if (widget.userType == 'patient') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserRegistrationPage(),
                    ),
                  );
                } else if (widget.userType == 'doctor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorRegistrationPage(),
                    ),
                  );
                }
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
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        selectedItemColor: Color(MyColors.primary),
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
                        ? BorderSide(color: Color(MyColors.bg01), width: 5)
                        : BorderSide.none,
                  ),
                ),
                child: Icon(
                  navigationBarItem['icon'],
                  color: _selectedIndex == 0
                      ? Color(MyColors.bg01)
                      : Color(MyColors.bg02),
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
      final List<dynamic> fetchedDoctors = await UserService.getAllUsers();
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
                    SizedBox(
                      width: 5,
                    ),
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
                  // Navigate to doctor chat page
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
