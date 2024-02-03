// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/models/rapport.dart';
import 'package:kch_kovm/tap_bar.dart';
import 'package:kch_kovm/utils/build_montee_descente_type_ahead_form_field.dart';
import 'package:kch_kovm/utils/build_style_button.dart';
import 'package:kch_kovm/utils/build_time_picker.dart';

class RapportScreen extends StatefulWidget {
  const RapportScreen({super.key});

  @override
  State<RapportScreen> createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
  // Get the current date and time
  List<String> equipeList = ['Kovm-1', 'Kovm-2', 'Kovm-3'];
  DateTime currentDate = DateTime.now();
  String? formattedDate;
  String? equipe;
  final TextEditingController serviceCtrl = TextEditingController();
  final TextEditingController equipeCtrl = TextEditingController();
  final TextEditingController departCtrl = TextEditingController();
  final TextEditingController pauseCtrl = TextEditingController();
  final TextEditingController finCtrl = TextEditingController();
  final TextEditingController vehiculeCtrl = TextEditingController();
  final TextEditingController kmsDepartCtrl = TextEditingController();
  final TextEditingController kmsFsCtrl = TextEditingController();
  final TextEditingController observationsCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? dateJour;
  String? idRapport;
  String? priseService;
  String? depart;
  String? pause;
  String? finService;
  String? observations;
  bool isRapport = false;

  //==============================================================
  Future<void> getRapport() async {
    try {
      formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

      var rapportData = await dbHelper.getRapportForCurrentDate();

      if (rapportData != null && rapportData.isNotEmpty) {
        final firstRapport = rapportData[0];

        if (firstRapport != null) {
          if (mounted) {
            setState(() {
              equipe = firstRapport['equipe']?.toString() ?? "";
              dateJour = firstRapport['dateJour']?.toString() ?? "";
              priseService = firstRapport['priseService']?.toString() ?? "";
              depart = firstRapport['depart']?.toString() ?? "";
              pause = firstRapport['pause']?.toString() ?? "";
              finService = firstRapport['finService']?.toString() ?? "";
              observations = firstRapport['observations']?.toString() ?? "";
              isRapport = true;
            });

            fillTextFieldsToUpdate();
          } else {
            if (mounted) {
              setState(() {
                equipe = "";
                priseService = "";
                depart = "";
                pause = "";
                finService = "";
                observations = "";
              });
            }
          }
        } else {
          isRapport = false;
        }
      } else {
        isRapport = false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //==============================================================
  fillTextFieldsToUpdate() {
    try {
      if (isRapport) {
        equipeCtrl.text = equipe!;
        serviceCtrl.text = priseService!;
        departCtrl.text = depart!;
        pauseCtrl.text = pause!;
        finCtrl.text = finService!;
        observationsCtrl.text = observations!;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    getRapport();
    super.initState();
  }

  @override
  void dispose() {
    serviceCtrl.dispose();
    equipeCtrl.dispose();
    departCtrl.dispose();
    pauseCtrl.dispose();
    finCtrl.dispose();
    vehiculeCtrl.dispose();
    kmsDepartCtrl.dispose();
    kmsFsCtrl.dispose();
    observationsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

    return Scaffold(
      appBar: AppBar(
        // title: homeButton(context, 'Prise de Service'),
        title: const Text('Prise de Service'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, top: 20, right: 40, bottom: 10),
          child: formBuild(),
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            if (_formKey.currentState!.validate()) {
              Rapport newRapport = Rapport(
                  equipe: equipeCtrl.text,
                  dateJour: formattedDate,
                  priseService: serviceCtrl.text,
                  depart: departCtrl.text,
                  pause: pauseCtrl.text,
                  finService: finCtrl.text,
                  observations: observationsCtrl.text);
              isRapport
                  ? (await dbHelper.updatePriseServiceByDate(
                      dateJour!, newRapport.toMap()))
                  : (await dbHelper.newRapportPriseService(
                      newRapport.toMap(), context));

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
        child: isRapport
            ? const Text(
                'Modifier',
                style: TextStyle(color: Colors.white),
              )
            : const Text('Valider', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildTextFormField(
      TextEditingController textCtrl, String labelText, IconData icon) {
    return TextFormField(
      controller: textCtrl,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: IconButton(
          onPressed: () {
            textCtrl.clear();
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
    );
  }

  void clearFields() {
    serviceCtrl.clear();
    equipeCtrl.clear();
    departCtrl.clear();
    pauseCtrl.clear();
    finCtrl.clear();
    vehiculeCtrl.clear();
    kmsDepartCtrl.clear();
    kmsFsCtrl.clear();
    observationsCtrl.clear();
  }

  Widget formBuild() {
    return Form(
      key: _formKey,
      child: Column(children: [
        buildMonteeDescenteTypeAheadFormField(
            context, 'Equipe', equipeCtrl, equipeList),
        const SizedBox(height: 10), // Spacer
        buildTimePicker(context, serviceCtrl, 'Prise Service'),
        const SizedBox(height: 10), // Spacer
        buildTimePicker(context, departCtrl, 'Départ dépôt'),
        const SizedBox(height: 10), // Spacer
        buildTimePicker(context, pauseCtrl, 'Pause'),
        const SizedBox(height: 10), // Spacer
        buildTimePicker(context, finCtrl, 'Fin Service'),
        const SizedBox(height: 10), // Spacer
        buildTextFormField(
            observationsCtrl, 'Observations', Icons.description_outlined),
        const SizedBox(height: 10), // Spacer
        buildSubmitButton()
      ]),
    );
  }
}
