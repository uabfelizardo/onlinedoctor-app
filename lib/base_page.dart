import 'package:flutter/material.dart';
import 'ReusableElements/AppBar/custom_app_bar.dart' as custom_app_bar;
import 'ReusableElements/AppBar/custom_drawer.dart' as custom_drawer; // Adjust import path

class BasePage extends StatelessWidget {
 // final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const BasePage({Key? key, required this.body, this.floatingActionButton,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const custom_app_bar.CustomAppBar(),
        drawer: const custom_drawer.CustomDrawer(),
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
