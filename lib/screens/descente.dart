// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/models/ligne.dart';
import 'package:kch_kovm/tap_bar.dart';
import 'package:kch_kovm/utils/build_home_button.dart';
import 'package:kch_kovm/utils/build_ligne_text_form_field.dart';
import 'package:kch_kovm/utils/build_montee_descente_type_ahead_form_field.dart';
import 'package:kch_kovm/utils/build_style_button.dart';
import 'package:kch_kovm/utils/build_time_picker.dart';

import '../../config/config.dart';

class UpdateLigne extends StatefulWidget {
  final Ligne? data;
  final int id;

  const UpdateLigne({
    Key? key,
    required this.data,
    required this.id,
  }) : super(key: key);

  @override
  State<UpdateLigne> createState() => _UpdateLigneState();
}

class _UpdateLigneState extends State<UpdateLigne> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
// Declaration of states
  TextEditingController ligneCtrl = TextEditingController();
  TextEditingController serviceCtrl = TextEditingController();
  TextEditingController busTramCtrl = TextEditingController();
  TextEditingController monteeCtrl = TextEditingController();
  TextEditingController heureMonteeCtrl = TextEditingController();
  TextEditingController descenteCtrl = TextEditingController();
  TextEditingController heureDescenteCtrl = TextEditingController();

  TextEditingController voyageursCtrl = TextEditingController();
  TextEditingController pvCtrl = TextEditingController();
  List<dynamic>? stopsList = [];
  String? ligne = '';
  int indexLigne = 0;
  final _formKey = GlobalKey<FormState>();

  /// IndexLigne VS Ligne *
  getIndexLigne(ligne) {
    switch (ligne) {
      case 'T9':
        return indexLigne = 0;
      case '480':
        return indexLigne = 1;
      case '482':
        return indexLigne = 2;
      case '483':
        return indexLigne = 3;
      case '282':
        return indexLigne = 4;
      case 'Licorne':
        return indexLigne = 5;
    }
  }

  // Fetch list of stops from the database
  Future<void> getStops() async {
    var stops = stopsData[ligne!.toLowerCase()];
    setState(() {
      stopsList = stops;
    });
  }

  /// show dialog before deleting the ligne
  void showDeleteDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer'),
          content: const Text('Voulez-vous supprimer cette ligne?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TapBar()),
                    (route) => false);
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                try {
                  dbHelper.deleteLigneById(widget.id);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const TapBar()),
                      (route) => false);
                } catch (e) {
                  throw Exception(e);
                }
              },
            ),
          ],
        );
      },
    );
  }

  ///Clear all Fields
  void clearFields() {
    ligneCtrl.clear();
    serviceCtrl.clear();
    busTramCtrl.clear();
    monteeCtrl.clear();
    heureMonteeCtrl.clear();
    descenteCtrl.clear();
    heureDescenteCtrl.clear();
    voyageursCtrl.clear();
    pvCtrl.clear();
  }

  @override
  void initState() {
    ligneCtrl.text = widget.data!.ligne!;
    serviceCtrl.text = widget.data!.service!;
    busTramCtrl.text = widget.data!.busTram!;
    monteeCtrl.text = widget.data!.montee!;
    heureMonteeCtrl.text = widget.data!.heureMontee!;

    descenteCtrl.text = widget.data?.descente ?? '';
    heureDescenteCtrl.text = widget.data?.heureDescente ?? '';

    voyageursCtrl.text = widget.data?.voyageurs?.toString() ?? '';
    pvCtrl.text = (widget.data?.pv)?.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    ligneCtrl.dispose();
    serviceCtrl.dispose();
    busTramCtrl.dispose();
    monteeCtrl.dispose();
    heureMonteeCtrl.dispose();
    descenteCtrl.dispose();
    heureDescenteCtrl.dispose();
    voyageursCtrl.dispose();
    pvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: homeButton(context, 'Descente'),
            backgroundColor: Colors.blue),
        body: Padding(
            padding:
                const EdgeInsets.only(left: 35, top: 25, right: 35, bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildContainer(),
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
                    const SizedBox(height: 10),
                    buildMonteeDescenteTypeAheadFormField(
                        context, "Descente", descenteCtrl, stopsList),
                    const SizedBox(height: 10),
                    buildTimePicker(
                        context, heureDescenteCtrl, 'Heure-Descente'),
                    const SizedBox(height: 10),
                    buildLigneTextFormField("Voyageurs", voyageursCtrl),
                    const SizedBox(height: 10),
                    buildLigneTextFormField("Pv", pvCtrl),
                    const SizedBox(height: 10),
                    buildSubmitButton(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )));
  }

  Widget buildContainer() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
        color: const Color.fromARGB(255, 243, 246, 246),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Action Contrôle',
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 22, 112, 248), // Text color
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDeleteDialog(context, widget.id);
            },
            color: Colors.red,
            iconSize: 25.0,
          ),
        ],
      ),
    );
  }

  Widget buildLigneTypeAheadFormField() {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: ligneCtrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: "Ligne",
            suffixIcon: IconButton(
              onPressed: () {
                ligneCtrl.clear();
                setState(() {
                  serviceCtrl.clear();
                  monteeCtrl.clear();
                  descenteCtrl.clear();
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
          // Fetch suggestions based on the pattern
          return lignesList
              .where(
                  (item) => item.toLowerCase().contains(pattern.toLowerCase()))
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
            if (ligne == "T9") {
              serviceCtrl.text = "Tram";
            }
          });
          getStops();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Linge?';
          }
          return null;
        });
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            if (_formKey.currentState!.validate()) {
              var ligneToUpdate = {
                "ligne": ligneCtrl.text,
                "service": serviceCtrl.text,
                "busTram": busTramCtrl.text,
                "montee": monteeCtrl.text,
                "heureMontee": heureMonteeCtrl.text,
                "descente": descenteCtrl.text,
                "heureDescente": heureDescenteCtrl.text,
                "voyageurs": voyageursCtrl.text,
                "pv": pvCtrl.text
              };
              await dbHelper.updateLigneById(widget.id, ligneToUpdate);
              clearFields();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TapBar()),
                  (route) => false);
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
