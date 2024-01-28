// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/tap_bar.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class StatEquipe extends StatefulWidget {
  const StatEquipe({super.key});

  @override
  State<StatEquipe> createState() => _StatEquipeState();
}

class _StatEquipeState extends State<StatEquipe> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
//Declaration of state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>>? statsOfAgent;
  List<Map<String, dynamic>>? result = [];
//============================================
// Get all Weekly Stats of each agent
  Future<void> getEquipeStats() async {
    try {
      result = await dbHelper.getAllStatAgents();
      if (result != null) {
        setState(() {
          statsOfAgent = result;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  initFunctions() async {
    await getEquipeStats();
  }

  @override
  void initState() {
    initFunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return statsOfAgent != null
        ? Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: statsOfAgent!.length,
                itemBuilder: (BuildContext context, int index) {
                  var dataSemaine = statsOfAgent![index];
                  var data = statsOfAgent![index]['data'];
                  if (data != null) {
                    var dataJour = data.where((data) {
                      String currentDate =
                          DateFormat('dd-MM-yyyy').format(DateTime.now());
                      return data['dateJour'] == currentDate;
                    }).toList();
                    return GestureDetector(
                      onTap: () {
                        var id = dataJour[0]['id'];

                        // Extract data values for the dialog
                        var pvJour = dataJour[0]['pv'];
                        var qpJour = dataJour[0]['qp'];
                        var montantJour = dataJour[0]['montant'];
                        var dateJour = dataJour[0]['dateJour'];
                        var name = dataSemaine['name'];
                        var surname = dataSemaine['surname'];
                        // Show the update stat dialog
                        showDialogUpdateStat(
                          id,
                          name,
                          surname,
                          pvJour,
                          qpJour,
                          montantJour,
                          dateJour,
                        );
                      },
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildColumnAgent(dataSemaine['name']),
                                  buildColumnStat(
                                      'PV-J',
                                      dataJour[0]['pv'] == null
                                          ? '0'
                                          : dataJour[0]['pv'].toString(),
                                      Colors.orangeAccent),
                                  buildColumnStat(
                                      'QP-J',
                                      dataJour[0]['qp'] == null
                                          ? '0'
                                          : (dataJour[0]['qp']).toString(),
                                      Colors.orangeAccent),
                                  buildColumnStat(
                                      '€€-J',
                                      dataJour[0]['montant'] == null
                                          ? '0'
                                          : dataJour[0]['montant'].toString(),
                                      Colors.orangeAccent),
                                  buildColumnStat(
                                      'PV-S',
                                      (dataSemaine['pvSemaine']).toString(),
                                      Colors.green),
                                  buildColumnStat(
                                      'QP-S',
                                      (dataSemaine['qpSemaine']).toString(),
                                      Colors.green),
                                  buildColumnStat(
                                      '€€-S',
                                      (dataSemaine['montantSemaine'])
                                          .toString(),
                                      Colors.green),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 5.0,
              percent: 1.0,
              center: const Text("80%"),
              progressColor: Colors.green,
            ),
          );
  }

  /// ************ Widget *****************
  Widget buildColumnAgent(name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$name', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildColumnStat(titre, qte, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$titre',
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 10),
        Text('$qte'),
      ],
    );
  }

  /// *********** Functions **************

  /// Show dialog add stat agent
  showDialogUpdateStat(
      id, name, surname, pvJour, qpJour, montantJour, formattedData) async {
    TextEditingController pvCtrl =
        TextEditingController(text: pvJour.toString());
    TextEditingController qpCtrl =
        TextEditingController(text: qpJour.toString());
    TextEditingController montantCtrl =
        TextEditingController(text: montantJour.toString());

    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$name ' ' $surname'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextFormField(pvCtrl, 'P-V'),
                buildTextFormField(qpCtrl, 'Q-P'),
                buildTextFormField(montantCtrl, 'Montant'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var updatedData = {
                    "pv": int.parse(pvCtrl.text),
                    "qp": int.parse(qpCtrl.text),
                    "montant": int.parse(montantCtrl.text),
                    "dateJour": formattedData
                  };

                  dbHelper.updateStatAgentById(id, updatedData);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const TapBar()),
                      (route) => false);
                }
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  /// ************ Widget *****************
  Widget buildTextFormField(textCtrl, labelText) {
    return TextFormField(
      controller: textCtrl,
      decoration: InputDecoration(labelText: '$labelText'),
      validator: (value) {
        if (value!.isEmpty) {
          return '$labelText?';
        }
        return null;
      },
      keyboardType:
          (labelText != 'P-V' && labelText != 'Q-P' && labelText != 'Montant')
              ? TextInputType.text
              : TextInputType.number,
    );
  }
}
