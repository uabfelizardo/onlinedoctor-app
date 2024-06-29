import 'package:flutter/material.dart';

const Color selectedBackgroundColor = Color.fromARGB(255, 55, 105, 101);
const Color selectedForegroundColor = Colors.white;
const Color unselectedBackgroundColor = Color.fromARGB(255, 229, 229, 229);
const Color unselectedForegroundColor = Colors.black;

class SortingOrderButton extends StatelessWidget {
  final List<bool> isSelected;
  final List<Widget> children;
  final ValueChanged<int>? onPressed;

  const SortingOrderButton({
    required this.isSelected,
    required this.children,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(isSelected.length == children.length);

    return ToggleButtons(
      isSelected: isSelected,
      onPressed: onPressed,
      color: unselectedForegroundColor, // Color of the unselected text
      selectedColor: selectedForegroundColor, // Color of the selected text
      fillColor: selectedBackgroundColor, // Background color of the selected button
      borderRadius: BorderRadius.circular(8.0),
      borderColor: selectedBackgroundColor,
      borderWidth: 2.0,
      children: List<Widget>.generate(
        children.length,
        (index) {
          bool selected = isSelected[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
            color: selected ? selectedBackgroundColor : unselectedBackgroundColor, // Background color logic
            child: Center(
              child: Text(
                (children[index] as Text).data ?? '',
                style: TextStyle(
                  color: selected ? selectedForegroundColor : unselectedForegroundColor, // Text color logic
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
