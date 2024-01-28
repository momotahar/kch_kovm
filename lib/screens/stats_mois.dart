import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/utils/build_column_ligne.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsMois extends StatefulWidget {
  const StatsMois({super.key});

  @override
  State<StatsMois> createState() => _StatsMoisState();
}

class _StatsMoisState extends State<StatsMois> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
//Declaration of state
  var filteredData = [];
  var filteredDataByMonth = [];
  List objectifsData = [13000, 2000, 150, 250, 100, 15];
  int tram = 0;
  int bus483 = 0;
  int bus482 = 0;
  int bus480 = 0;
  int bus282 = 0;
  int busLicorne = 0;
  String? monthName;
  String? result;
  int? difference;
  String? ligne;
  String? donne;

  /// function to calculate the total left of each gol to reach
  int totalLeft(ligne, donne) {
    tram = objectifsData[0];
    bus483 = objectifsData[1];
    bus482 = objectifsData[2];
    bus480 = objectifsData[3];
    bus282 = objectifsData[4];
    busLicorne = objectifsData[5];
    switch (ligne) {
      case "T9":
        return difference = (int.parse(donne) - tram);
      case "483":
        return difference = (int.parse(donne) - bus483);
      case "482":
        return difference = (int.parse(donne) - bus482);
      case "480":
        return difference = (int.parse(donne) - bus480);
      case "282":
        return difference = (int.parse(donne) - bus282);
      case "Licorne":
        return difference = (int.parse(donne) - busLicorne);

      default:
        return difference!;
    }
  }

//Get Stats by Month for each ligne
  Future<void> filteredStatByMonth() async {
    try {
      var res = await dbHelper.getSummaryForCurrentMonth();
      if (mounted) {
        setState(() {
          filteredDataByMonth = res;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    filteredStatByMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    // ignore: unnecessary_null_comparison
    return filteredData != null
        ? Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: filteredDataByMonth.length,
                itemBuilder: (context, index) {
                  String monthName = DateFormat('MMM').format(
                      DateFormat('dd-MM-yyyy')
                          .parse(filteredDataByMonth[index]['dateJour']));
                  ligne = filteredDataByMonth[index]['ligne'];
                  donne = filteredDataByMonth[index]['totalVoyageursSum']
                      .toString();
                  totalLeft(ligne, donne);
                  Color textColor = difference != null && difference! >= 0
                      ? Colors.green
                      : Colors.red;
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
                                    monthName.toString(),
                                    style:
                                        const TextStyle(color: Colors.orange),
                                  )
                                ],
                              ),
                              buildColumnLigne(
                                  filteredDataByMonth[index]['ligne'],
                                  Icons.directions_subway_outlined,
                                  Colors.blue),
                              buildColumnLigne(
                                  filteredDataByMonth[index]['totalCount']
                                      .toString(),
                                  Icons.note_add_outlined,
                                  Colors.blue),
                              buildColumnLigne(
                                  filteredDataByMonth[index]
                                          ['totalVoyageursSum']
                                      .toString(),
                                  Icons.group,
                                  Colors.blue),
                              Column(
                                children: [
                                  Icon(
                                    Icons.group,
                                    color: textColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      difference
                                          .toString(), // Display the result or an empty string
                                      style: TextStyle(color: textColor))
                                ],
                              ),
                              buildColumnLigne(
                                  filteredDataByMonth[index]['totalPvSum']
                                      .toString(),
                                  Icons.description_outlined,
                                  Colors.blue),
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
