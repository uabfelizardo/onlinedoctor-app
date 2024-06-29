import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/home_page.dart';
import 'package:onlinedoctorapp/Doctors/doctor_list_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Agendar Consulta'),
            onTap: () {
              // Implement navigation to Agendar Consulta page
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_list),
            title: const Text('Visualizar Consultas'),
            onTap: () {
              // Implement navigation to Visualizar Consultas page
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('Visualizar Médicos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DoctorListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
    );
  }
}
