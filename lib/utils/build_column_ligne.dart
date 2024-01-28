import 'package:flutter/material.dart';

Widget buildColumnLigne(String text, IconData icon, Color col) {
  return Column(
    children: [
       Icon(
        icon,
        color: col,
      ),
      const SizedBox(
        height: 5,
      ),
      Text(text),
    ],
  );
}
