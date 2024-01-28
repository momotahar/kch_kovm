// ignore_for_file: file_names

import 'package:flutter/material.dart';

//TextFromField
Widget buildTextFormField(
  TextEditingController textCtrl,
  String labelText,
  IconData icon,
) {
  return TextFormField(
    controller: textCtrl,
    obscureText: labelText == 'Mot de Passe' ? true : false,
    decoration: InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(
        icon,
        color: Colors.blue,
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return '$labelText?';
      }
      return null;
    },
  );
}
