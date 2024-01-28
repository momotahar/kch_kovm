// Time Picker
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> selectTime(context, TextEditingController timeCtrl) async {
  TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (selectedTime != null) {
    final formattedTime = DateFormat.Hm()
        .format(DateTime(2000, 1, 1, selectedTime.hour, selectedTime.minute));

    timeCtrl.text = formattedTime;
  }
}

Widget buildTimePicker(
    context, TextEditingController timeCtrl, String labelText) {
  return TextFormField(
    controller: timeCtrl,
    readOnly: true,
    onTap: () => selectTime(context, timeCtrl),
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
      suffixIcon: IconButton(
        onPressed: () {
          timeCtrl.clear();
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
      timeCtrl.text = value.toString();
    },
  );
}
