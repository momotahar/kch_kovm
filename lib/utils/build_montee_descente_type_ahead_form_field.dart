// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Widget buildMonteeDescenteTypeAheadFormField(
    context, text, TextEditingController textCtrl, List<dynamic>? stopsList) {
  return TypeAheadFormField(
    textFieldConfiguration: TextFieldConfiguration(
      controller: textCtrl,
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: IconButton(
          onPressed: () {
            textCtrl.clear();
          },
          icon: const Icon(
            Icons.close,
            color: Colors.blue,
          ),
        ),
        border: const OutlineInputBorder(),
        hintText: text,
      ),
    ),
    suggestionsCallback: (pattern) async {
      return stopsList!
          .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    onSuggestionSelected: (suggestion) {
      textCtrl.text = suggestion;
    },
    validator: (value) {
      if (value!.isEmpty) {
        return '$text?';
      }
      return null;
    },
  );
}
