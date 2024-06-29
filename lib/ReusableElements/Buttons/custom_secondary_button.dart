import 'package:flutter/material.dart';

final ButtonStyle secondaryButtonStyle = TextButton.styleFrom(
  backgroundColor: const Color(0xFF8CA09D),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  textStyle: const TextStyle(fontSize: 16),
);

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryButton({required this.label, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: secondaryButtonStyle,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
