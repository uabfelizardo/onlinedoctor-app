import 'package:flutter/material.dart';
import 'AppBar/custom_app_bar.dart' as custom_app_bar;
import 'AppBar/custom_drawer.dart' as custom_drawer; // Adjust import path

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;

  const BasePage({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: custom_app_bar.CustomAppBar(title: title),
        drawer: const custom_drawer.CustomDrawer(),
        body: body,
      ),
    );
  }
}
