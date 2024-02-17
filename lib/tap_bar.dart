import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/provider/prise_service.dart';
import 'package:kch_kovm/screens/clean_table.dart';
import 'package:kch_kovm/screens/excel_screen.dart';
import 'package:kch_kovm/screens/feuille_route.dart';
import 'package:kch_kovm/screens/file_picker.dart';
import 'package:kch_kovm/screens/list_agents.dart';
import 'package:kch_kovm/screens/montee.dart';
import 'package:kch_kovm/screens/new_agent.dart';
import 'package:kch_kovm/screens/service_rapport.dart';
import 'package:kch_kovm/screens/stat_equipe.dart';
import 'package:kch_kovm/screens/stats_jour.dart';
import 'package:kch_kovm/screens/stats_mois.dart';
import 'package:kch_kovm/utils/build_popup_menuI_tem.dart';
import 'package:provider/provider.dart';

class TapBar extends StatefulWidget {
  const TapBar({super.key});

  @override
  State<TapBar> createState() => _TapBarState();
}

class _TapBarState extends State<TapBar> {
  //Initialize DbHelper
  DatabaseHelper databaseHelper = DatabaseHelper();

  //States declaration
  DateTime currentDate = DateTime.now();
  String? formattedDate;
  String? equipe;

  void getEquipeToString() async {
    var team = await Provider.of<PriseServiceProvider>(context, listen: false)
        .getEquipeName();
    if (mounted) {
      setState(() {
        equipe = team;
      });
    }
  }

  @override
  void initState() {
    formattedDate = DateFormat('dd-MMM-yyyy', 'fr').format(currentDate);
    // initFunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getEquipeToString();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$formattedDate',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$equipe',
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Agents':
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AgentListScreen()),
                          (route) => false);
                      break;
                    case 'Prise de Service':
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RapportScreen()),
                          (route) => false);
                      break;
                    case 'Excel':
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExcelDocScreen()),
                          (route) => false);
                      break;
                    case 'Fichier':
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FilePickerScreen()),
                          (route) => false);
                      break;
                    case 'Stockage':
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CleanDatabaseScreen()),
                          (route) => false);
                      break;
                    case 'Nouvel Agent':
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewAgentScreen()),
                          (route) => false);
                      break;

                    default:
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    buildPopupMenuItem('Prise de Service',
                        Icons.description_outlined, 'Prise de Service'),
                    const PopupMenuDivider(), // Divider between items
                    buildPopupMenuItem(
                        'Nouvel Agent', Icons.person_add, 'Nouvel Agent'),
                    const PopupMenuDivider(), // Divider between items
                    buildPopupMenuItem('Agents', Icons.person_add, 'Agents'),
                    const PopupMenuDivider(), // Divider between items
                    buildPopupMenuItem(
                        'Excel', Icons.table_chart_outlined, 'Excel'),
                    const PopupMenuDivider(), // Divider between items
                    buildPopupMenuItem(
                        'Fichier', Icons.file_download, 'Fichier'),
                    const PopupMenuDivider(), // Divider between items
                    buildPopupMenuItem('Stockage', Icons.settings, 'Stockage'),
                  ];
                },
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Liste'),
              Tab(text: 'Montée'),
              Tab(text: 'Stat-J'),
              Tab(text: 'Stat-M'),
              Tab(text: 'Equipe'),
            ],
            labelColor: Colors.white,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.orange, width: 7.0),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            // Liste for Tab 1
            FeuilleDeRoute(),
            // Ajouter for Tab 2
            Montee(),
            // Statistiques jour for Tab 3
            StatsJour(),
            // Statistiques mois for Tab 4
            StatsMois(),
            // Statistiques agent for Tab 5
            StatEquipe(),
          ],
        ),
      ),
    );
  }
}
