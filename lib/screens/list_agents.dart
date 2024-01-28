import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/models/stat_agent.dart';
import 'package:kch_kovm/utils/build_home_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AgentListScreen extends StatefulWidget {
  const AgentListScreen({super.key});

  @override
  State<AgentListScreen> createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();
  //Declaration fo stats
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var agents = [];
  String? jour;

  // Date of the day
  DateTime currentDate = DateTime.now();

  /// Get All Agents by userId team
  Future<void> getListAgents() async {
    var res = await dbHelper.getAllAgents();
    if (res != null) {
      if (mounted) {
        setState(() {
          agents = res;
        });
      }
    }
  }

  @override
  void initState() {
    getListAgents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
    // Get the name of the day of the week
    jour = DateFormat.EEEE('fr_FR').format(currentDate);
    return Scaffold(
        appBar: AppBar(
            title: homeButton(context, 'Liste des Agents'),
            backgroundColor: Colors.blue),
        body: agents.isNotEmpty
            ? Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 20, right: 15, bottom: 10),
                  child: ListView.builder(
                    itemCount: agents.length,
                    itemBuilder: (BuildContext context, int index) {
                      var matricule = agents[index]['matricule'];
                      var name = agents[index]['name'];
                      var surname = agents[index]['surname'];
                      var id = agents[index]['id'];

                      return GestureDetector(
                        onTap: () async {
                          await dbHelper.checkStatAgent(
                                  matricule, formattedDate, context)
                              // ignore: use_build_context_synchronously
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Statistiques déjà saisies!'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                )
                              : showDialogAddStat(matricule, name, surname, id,
                                  formattedDate, jour);
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
                                    buildColumnAgent(matricule),
                                    buildColumnAgent(name),
                                    buildColumnAgent(surname),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.green, size: 20),
                                      onPressed: () {
                                        showDialogUpdate(
                                            matricule, name, surname, id);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 20),
                                      onPressed: () {
                                        showDeleteDialog(context, id);
                                      },
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
              ));
  }

  /// *********** Functions **************
  //Function to get the current week number
  int? getWeekNumberFromCurrentDate() {
    // Get the current date
    try {
      DateTime now = DateTime.now();
      // Calculate the difference between the current date and the first day of the year
      int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      // Calculate the week number
      int weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
      return weekNumber;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Show dialog add stat agent
  showDialogAddStat(matricule, name, surname, id, date, jour) async {
    TextEditingController pvCtrl = TextEditingController();
    TextEditingController qpCtrl = TextEditingController();
    TextEditingController montantCtrl = TextEditingController();

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
                try {
                  if (_formKey.currentState!.validate()) {
                    StatAgentModel statAgentModel = StatAgentModel(
                        matricule: matricule,
                        name: name,
                        surname: surname,
                        pv: int.parse(pvCtrl.text),
                        qp: int.parse(qpCtrl.text),
                        montant: int.parse(montantCtrl.text),
                        week: getWeekNumberFromCurrentDate(),
                        dateJour: date,
                        jour: jour);
                    dbHelper.newStatAgent(statAgentModel.toJson());
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  throw Exception(e);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  /// Show dialog update agent
  showDialogUpdate(matricule, name, surname, id) async {
    TextEditingController nameCtrl = TextEditingController(text: name);
    TextEditingController surnameCtrl = TextEditingController(text: surname);
    TextEditingController matriculeCtrl =
        TextEditingController(text: matricule);

    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$name ' ' $surname'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextFormField(nameCtrl, 'Nom'),
                  buildTextFormField(surnameCtrl, 'Prénom'),
                  buildTextFormField(matriculeCtrl, 'Matricule'),
                ],
              ),
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
                  var data = {
                    'name': (nameCtrl.text).toUpperCase(),
                    'surname': (surnameCtrl.text)[0].toUpperCase() +
                        (surnameCtrl.text).substring(1),
                    'matricule': matriculeCtrl.text
                  };
                  dbHelper.updateAgentById(id, data);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AgentListScreen()),
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

  ///
  Widget buildColumnAgent(name) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$name', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  /// show dialog before deleting the ligne
  void showDeleteDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer'),
          content: const Text('Voulez-vous supprimer cet agent?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                dbHelper.deleteAgentById(id);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AgentListScreen()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
