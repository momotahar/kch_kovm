import 'package:flutter/material.dart';

import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/utils/build_column_ligne.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsJour extends StatefulWidget {
  const StatsJour({super.key});

  @override
  State<StatsJour> createState() => _StatsJourState();
}

class _StatsJourState extends State<StatsJour> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
//Declaration of state
  var filteredDataByDay = [];
  String? jour;

  /// split data and take what needed
  splitString(String inputDate) {
    List<String> parts = inputDate.split("-");
    String result = "${parts[0]}-${parts[1]}";
    return result;
  }

  Future<void> filteredStatByDay() async {
    try {
      var res = await dbHelper.getStatsForEachLigneOnCurrentDate();
      if (mounted) {
        setState(() {
          filteredDataByDay = res;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    filteredStatByDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return filteredDataByDay != null
        ? Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: filteredDataByDay.length,
                itemBuilder: (context, index) {
                  jour = splitString(filteredDataByDay[index]['dateJour']);
                  return Card(
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    jour.toString(),
                                    style:
                                        const TextStyle(color: Colors.orange),
                                  )
                                ],
                              ),
                              buildColumnLigne(
                                  filteredDataByDay[index]['ligne'],
                                  Icons.directions_subway_outlined,
                                  Colors.blue),
                              buildColumnLigne(
                                  filteredDataByDay[index]['totalCount']
                                      .toString(),
                                  Icons.note_add_outlined,
                                  Colors.blue),
                              buildColumnLigne(
                                  filteredDataByDay[index]['totalVoyageursSum']
                                      .toString(),
                                  Icons.group,
                                  Colors.blue),
                              buildColumnLigne(
                                  filteredDataByDay[index]['totalPvSum']
                                      .toString(),
                                  Icons.description_outlined,
                                  Colors.blue)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 5.0,
                percent: 1.0,
                center: const Text("80%"),
                progressColor: Colors.green,
              ),
            ),
          );
  }
}
