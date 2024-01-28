import 'package:flutter/material.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/home.dart';
import 'package:kch_kovm/utils/build_home_button.dart';
import 'package:kch_kovm/utils/build_style_button.dart';

class CleanDatabaseScreen extends StatefulWidget {
  const CleanDatabaseScreen({super.key});

  @override
  State<CleanDatabaseScreen> createState() => _CleanDatabaseScreenState();
}

class _CleanDatabaseScreenState extends State<CleanDatabaseScreen> {
  //initialize the database helper
  DatabaseHelper dbHelper = DatabaseHelper();

  /// show dialog before deleting the ligne
  void showCleanDatabaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer'),
          content:
              const Text('Voulez-vous supprimer toutes les actions contrôle?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                try {
                  await dbHelper.cleanTable();
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: homeButton(context, 'Suppression des Données'),
          backgroundColor: Colors.blue),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCleanDatabaseDialog(context);
          },
          style: buildStyle(Colors.red, 150, 50),
          child: const Text(
            'Suppression',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
