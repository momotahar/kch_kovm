// ignore_for_file: file_names

import 'package:flutter/material.dart';

buildPopupMenuItem(String value, IconData icon, String text) {
  return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ));
}
