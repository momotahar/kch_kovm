// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/models/ligne.dart';
import 'package:kch_kovm/utils/build_column_ligne.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kch_kovm/screens/descente.dart';

class FeuilleDeRoute extends StatefulWidget {
  const FeuilleDeRoute({super.key});

  @override
  State<FeuilleDeRoute> createState() => _FeuilleDeRouteState();
}

class _FeuilleDeRouteState extends State<FeuilleDeRoute> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> lignes = [];
  Ligne? ligne;
  int id = 0;
  var filteredData = [];
  // Get the current date and time
  DateTime? currentDate = DateTime.now();
// Format the date to the desired format
  String? formattedDate;

  fetchAllLignes() async {
    try {
      var res = await dbHelper.getLignesForCurrentDate();
      if (res != null) {
        if (mounted) {
          setState(() {
            lignes = res;
          });
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    fetchAllLignes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    // ignore: unnecessary_null_comparison
    return lignes != null
        ? Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: lignes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ligne = Ligne.fromMap(lignes[index]);
                      id = lignes[index]['id'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateLigne(data: ligne, id: id)));
                    },
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildColumnLigne(
                                    lignes[index]['ligne'],
                                    Icons.directions_subway_outlined,
                                    Colors.blue),
                                buildColumnLigne(lignes[index]['heureMontee'],
                                    Icons.timer_outlined, Colors.blue),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.timer_outlined,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    lignes[index]['heureDescente'] != null
                                        ? Text(
                                            lignes[index]['heureDescente']
                                                .toString(),
                                          )
                                        : const Text(
                                            '---',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.group,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    lignes[index]['voyageurs'] != null
                                        ? Text((lignes[index]['voyageurs'])
                                            .toString())
                                        : const Text('---',
                                            style: TextStyle(color: Colors.red))
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.description_outlined,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    lignes[index]['pv'] != null
                                        ? Text((lignes[index]['pv']).toString())
                                        : const Text('---',
                                            style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
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
}
