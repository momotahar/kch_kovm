import 'package:flutter/material.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/screens/service_rapport.dart';
import 'package:kch_kovm/tap_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  bool isChecked = false;
  Future<void> checkPriseService() async {
    var priseService = await dbHelper.getRapportForCurrentDate();
    if (priseService!.isNotEmpty) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  @override
  void initState() {
    checkPriseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isChecked ? const TapBar() : const RapportScreen();
  }
}
