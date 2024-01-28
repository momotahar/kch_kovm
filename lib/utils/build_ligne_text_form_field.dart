import 'package:flutter/material.dart';

Widget buildLigneTextFormField(
    String labelText, TextEditingController controller,
    {bool readOnly = false, Function()? onTap}) {
  return TextFormField(
    controller: controller,
    readOnly: readOnly,
    keyboardType: (labelText == 'Voyageurs' || labelText == 'Pv')
        ? TextInputType.number
        : TextInputType.text,
    onTap: onTap,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
      suffixIcon: IconButton(
        onPressed: () {
          controller.clear();
        },
        icon: const Icon(
          Icons.close,
          color: Colors.blue,
        ),
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return '$labelText?';
      }
      return null;
    },
    onSaved: (value) {
      controller.text = value.toString();
    },
  );
}
