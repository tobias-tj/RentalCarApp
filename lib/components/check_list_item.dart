import 'package:flutter/material.dart';

class ChecklistItem extends StatelessWidget {
  final String text;
  final bool isChecked;

  const ChecklistItem({Key? key, required this.text, required this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isChecked
              ? Colors.green
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isChecked ? Colors.green : Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
