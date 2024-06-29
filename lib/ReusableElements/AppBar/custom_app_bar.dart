import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
 // final String title;

  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    //  title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Agendar Consulta'),
            onTap: () {
              // Add navigation or action
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Visualizar Consultas'),
            onTap: () {
              // Add navigation or action
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Visualizar Médicos'),
            onTap: () {
              // Add navigation or action
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Add navigation or action
            },
          ),
        ],
      ),
    );
  }
}
