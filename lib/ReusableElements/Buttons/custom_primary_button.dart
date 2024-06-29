import 'package:flutter/material.dart';

final ButtonStyle primaryButtonStyle = TextButton.styleFrom(
  backgroundColor: const Color(0xFF63B2A9),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  textStyle: const TextStyle(fontSize: 16),
);

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({required this.label, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: primaryButtonStyle,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}