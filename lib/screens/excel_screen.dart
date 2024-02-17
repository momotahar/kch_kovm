// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/excel/feuille_route.dart';
import 'package:kch_kovm/excel/stat_bus.dart';
import 'package:kch_kovm/excel/stat_weekly.dart';
import 'package:kch_kovm/provider/prise_service.dart';
import 'package:kch_kovm/utils/build_home_button.dart';
import 'package:kch_kovm/utils/build_scaffold_message.dart';
import 'package:kch_kovm/utils/build_style_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../models/ligne.dart';

class ExcelDocScreen extends StatefulWidget {
  const ExcelDocScreen({super.key});

  @override
  State<ExcelDocScreen> createState() => _ExcelDocScreenState();
}

class _ExcelDocScreenState extends State<ExcelDocScreen> {
//Declaration of state
  DatabaseHelper dbHelper = DatabaseHelper();
  DateTime currentDate = DateTime.now();
  TextEditingController dateCtrl = TextEditingController();
  String? equipe;
  String? inputDate;
  String? formattedDate;

  String priseService = '';
  String depart = '';
  String pause = '';
  String finService = '';
  String observations = '';
  var statics = [];
  List stats = [];
  List<Map<String, dynamic>> listAgentData = [];

  List<dynamic>? lignes;
  List<List<dynamic>> feuilleRoute = [];
  Ligne? ligne;

  // Function to request permissions
  Future<void> requestPermissions() async {}

//Get equipe name from Provider
  Future<void> getEquipeToString() async {
    try {
      var team = await Provider.of<PriseServiceProvider>(context, listen: false)
          .getEquipeName();
      if (team != null) {
        if (mounted) {
          setState(() {
            equipe = team;
          });
        }
      } else {
        equipe = 'Kovm';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// fetch list of lignes
  Future<void> fetchDailyLignes() async {
    try {
      lignes = await dbHelper.getLignesForCurrentDate();
      if (lignes!.isNotEmpty) {
        if (mounted) {
          setState(() {
            for (dynamic ligne in lignes!) {
              List<dynamic> itemData = [
                ligne['ligne'],
                ligne['service'],
                ligne['busTram'],
                ligne['montee'],
                ligne['heureMontee'],
                ligne['descente'],
                ligne['heureDescente'],
                ligne['voyageurs'],
                ligne['pv'],
              ];
              feuilleRoute.add(itemData);
            }
          });
        }
      } else {
        print('Pas de données');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//=================Util Functions===============
  DateTime parseDate(String dateString) {
    try {
      List<String> parts = dateString.split('-');
      int year = int.parse(parts[2]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[0]);
      return DateTime(year, month, day);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// fetch list of lignes
  Future<void> statEachTeam() async {
    try {
      int currentMonthNumber = DateTime.now().month;
      final response = await dbHelper.statEachTeamDaily();
      if (response.isNotEmpty) {
        setState(() {
          statics = response
              .where((stat) =>
                  DateTime.parse(DateFormat("dd-MM-yyyy")
                          .parse(stat['dateJour'])
                          .toString())
                      .month ==
                  currentMonthNumber)
              .toList();
        });
      } else {
        print('Les données n\'ont pas pu être envoyer');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//==============================================================
  Future<void> getRapport() async {
    formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

    try {
      final response = await dbHelper.getRapportForCurrentDate();

      if (response!.isNotEmpty) {
        if (mounted) {
          setState(() {
            priseService = response[0]['priseService'].toString();
            depart = response[0]['depart'].toString();
            pause = response[0]['pause'].toString();
            finService = response[0]['finService'].toString();
            observations = response[0]['observations'].toString();
          });
        }
      } else {
        print('Data could not be fetched');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //====================================================
  //Get all stats agent
  Future<void> getStatsEquipe() async {
    try {
      var result = await dbHelper.getAllStatAgents();
      if (result != null) {
        setState(() {
          listAgentData = result;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //====================================================
  Future<void> initializeData() async {
    formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
    try {
      await getEquipeToString();
      await fetchDailyLignes();
      await getRapport();
      await statEachTeam();
      await getStatsEquipe();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: homeButton(context, 'Document Excel'),
          backgroundColor: Colors.blue),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () async {
              // Request external storage permission
              var status = await Permission.storage.request();
              if (status.isGranted) {
                createExcelFileFeuilleRoute(context, equipe!, feuilleRoute,
                    priseService, depart, pause, finService, observations);
                createExcelFileStatWeekly(context, equipe, listAgentData);
                createExcelFileStatBusTram(context, equipe, statics);
                buildScaffoldMessage(
                    context, "Document Excel créé avec succès");

                print("Storage permission granted");
              } else if (status.isDenied) {
                // Permission denied, show a dialog or message to the user explaining why you need the permission
                print("Storage permission denied");
              } else if (status.isPermanentlyDenied) {
                // Permission permanently denied, open app settings so the user can enable the permission manually
                print("Storage permission permanently denied");
                openAppSettings();
              }
            },
            style: buildStyle(Colors.blueAccent, 200, 50),
            child: const Text(
              'Document Excel',
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            ),
          ),
        ),
      ),
    );
  }
}
