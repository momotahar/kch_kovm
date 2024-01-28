// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kch_kovm/database/database_helper.dart';

class PriseServiceProvider extends ChangeNotifier {
  //Declaration of state
  DatabaseHelper dbHelper = DatabaseHelper();
  String? equipe;
  final List<Map<String, dynamic>> _dataList = [];

  List<Map<String, dynamic>> get dataList => _dataList;

  // Method to add data to the provider
  void addData(Map<String, dynamic> data) {
    _dataList.add(data);
    notifyListeners();
  }

  // Method to get rapport for the current date

  Future<String?> getEquipeName() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();

      var rapportData = await dbHelper.getRapportForCurrentDate();
      if (rapportData != null && rapportData.isNotEmpty) {
        final firstRapport = rapportData[0];
        equipe = firstRapport['equipe'].toString();
      } else {
        return "Kovm";
      }
    } catch (e) {
      throw Exception(e);
    }
    return equipe;
  }
}
