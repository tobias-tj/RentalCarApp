import 'package:flutter/material.dart';
import 'package:rental_car_app/components/check_list_item.dart';

class PasswordValidationChecklist extends StatelessWidget {
  final bool containsUpperCase;
  final bool containsLowerCase;
  final bool containsNumber;
  final bool containsSpecialChar;
  final bool contains8Length;

  const PasswordValidationChecklist({
    Key? key,
    required this.containsUpperCase,
    required this.containsLowerCase,
    required this.containsNumber,
    required this.containsSpecialChar,
    required this.contains8Length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0, // Espacio entre los elementos
      runSpacing: 8.0,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChecklistItem(
              text: "1 uppercase letter",
              isChecked: containsUpperCase,
            ),
            ChecklistItem(
              text: "1 lowercase letter",
              isChecked: containsLowerCase,
            ),
            ChecklistItem(
              text: "1 number",
              isChecked: containsNumber,
            ),
            ChecklistItem(
              text: "1 special character",
              isChecked: containsSpecialChar,
            ),
            ChecklistItem(
              text: "8 characters minimum",
              isChecked: contains8Length,
            ),
          ],
        ),
      ],
    );
  }
}
