import 'package:flutter/material.dart';

Widget customContainer(String text) {
  return Container(
    padding: const EdgeInsets.all(14.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.grey),
      color: const Color.fromARGB(255, 243, 246, 246),
    ),
    child: Text(
      text,
      style: const TextStyle(
        letterSpacing: 2,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 22, 112, 248), // Text color
      ),
    ),
  );
}
