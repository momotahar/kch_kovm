// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/config/config.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/models/ligne.dart';
import 'package:kch_kovm/tap_bar.dart';
import 'package:kch_kovm/utils/build_head_container.dart';
import 'package:kch_kovm/utils/build_ligne_text_form_field.dart';
import 'package:kch_kovm/utils/build_montee_descente_type_ahead_form_field.dart';
import 'package:kch_kovm/utils/build_style_button.dart';
import 'package:kch_kovm/utils/build_time_picker.dart';

class Montee extends StatefulWidget {
  const Montee({super.key});

  @override
  State<Montee> createState() => _MonteeState();
}

class _MonteeState extends State<Montee> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
  // Declaration of states
  TextEditingController ligneCtrl = TextEditingController();
  TextEditingController serviceCtrl = TextEditingController();
  TextEditingController busTramCtrl = TextEditingController();
  TextEditingController monteeCtrl = TextEditingController();
  TextEditingController heureMonteeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? ligne = '';
  DateTime currentDate = DateTime.now();
  String? formattedDate;
  List<dynamic>? stopsList = [];

  //Instance fo the database manager

  // Fetch list of stops
  Future<void> getStops() async {
    try {
      var stops = stopsData[ligne!.toLowerCase()];
      setState(() {
        stopsList = stops;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  // Clear all Fields
  void clearFields() {
    ligneCtrl.clear();
    serviceCtrl.clear();
    busTramCtrl.clear();
    monteeCtrl.clear();
    heureMonteeCtrl.clear();
  }

  @override
  void initState() {
    formattedDate = DateFormat('dd-MMM-yyyy').format(currentDate);
    super.initState();
  }

  @override
  void dispose() {
    ligneCtrl.dispose();
    serviceCtrl.dispose();
    busTramCtrl.dispose();
    monteeCtrl.dispose();
    heureMonteeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
    return buildMonteeLigneForm();
  }

  Widget buildMonteeLigneForm() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

    return Padding(
      padding: const EdgeInsets.only(left: 35, top: 30, right: 35, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              customContainer('Montée'),
              const SizedBox(height: 10),
              buildLigneTypeAheadFormField(),
              const SizedBox(height: 10),
              buildLigneTextFormField("Service", serviceCtrl),
              const SizedBox(height: 10),
              buildLigneTextFormField("Numéro Bus-Tram", busTramCtrl),
              const SizedBox(height: 10),
              buildMonteeDescenteTypeAheadFormField(
                  context, "Montée", monteeCtrl, stopsList),
              const SizedBox(height: 10),
              buildTimePicker(context, heureMonteeCtrl, 'Heure-Montée'),
              const SizedBox(height: 15),
              buildSubmitButton(formattedDate, 'id'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLigneTypeAheadFormField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: ligneCtrl,
        autofocus: false,
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(fontStyle: FontStyle.normal),
        decoration: InputDecoration(
          labelText: "Ligne",
          suffixIcon: IconButton(
            onPressed: () {
              ligneCtrl.clear();
              setState(() {
                serviceCtrl.clear();
                monteeCtrl.clear();
                // descenteCtrl.clear();
                stopsList = [];
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.blue,
            ),
          ),
          border: const OutlineInputBorder(),
          hintText: "Ligne",
        ),
      ),
      suggestionsCallback: (pattern) async {
        return lignesList
            .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        ligneCtrl.text = suggestion;
        setState(() {
          ligne = ligneCtrl.text;
          if (ligne?.toLowerCase() == "t9") {
            serviceCtrl.text = "Tram";
          }
        });
        getStops();
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ligne?';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton(String formattedDate, id) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            if (_formKey.currentState!.validate()) {
              Ligne newLigne = Ligne(
                  ligne: ligneCtrl.text,
                  service: serviceCtrl.text,
                  busTram: busTramCtrl.text,
                  montee: monteeCtrl.text,
                  heureMontee: heureMonteeCtrl.text,
                  dateJour: formattedDate);
              await dbHelper.insert(newLigne.toMap());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TapBar()),
                  (route) => false);
              clearFields();
            }
          } catch (e) {
            throw Exception(e);
          }
        },
        style: buildStyle(Colors.blueAccent, 150, 50),
        child: const Text("Valider", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
