import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kch_kovm/home.dart';
import 'package:kch_kovm/provider/prise_service.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('fr', null).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => PriseServiceProvider(),
        child: const MainApp(),
      ),
    );

  });
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
