// ignore_for_file: file_names

import 'package:flutter/material.dart';

buildObjectifsTextFormField(TextEditingController tramCtrl, String labelText) {
  return TextFormField(
    controller: tramCtrl,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: labelText,
      suffixIcon: IconButton(
        onPressed: () {
          tramCtrl.clear();
        },
        icon: const Icon(Icons.close, color: Colors.blue),
      ),
      border: const OutlineInputBorder(),
      prefixIcon: const Icon(Icons.group_outlined, color: Colors.blue),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter a number';
      }
      return null;
    },
  );
}
