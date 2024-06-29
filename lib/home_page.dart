import 'package:flutter/material.dart';
import 'base_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      body: Center(
        child: Text('Content of Another Page'),
      ),
    );
  }
}
