import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
              fontSize: 12, color: Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }
}
