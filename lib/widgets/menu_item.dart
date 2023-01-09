  import 'package:flutter/material.dart';

PopupMenuItem<String> menuItem({
  required String text,
  required IconData iconData,
  required String value,
}) {
  return PopupMenuItem<String>(
    value: value,
    child: Row(
      children: [
        Icon(iconData),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}
