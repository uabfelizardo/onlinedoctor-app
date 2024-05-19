import 'package:flutter/material.dart';
import 'AppBar/custom_app_bar.dart';
import 'Doctors/doctor_list_page.dart'; // Import your doctor list page

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home Page'),
      drawer: const CustomDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const DoctorListPage();
            }));
          },
          child: const Text('Go to Doctor List'),
        ),
      ),
    );
  }
}
