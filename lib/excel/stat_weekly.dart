// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

// Date of the day
List<String> daysOfWeek = [
  "lundi",
  "mardi",
  "mercredi",
  "jeudi",
  "vendredi",
  "samedi",
  "dimanche"
];

//Get the number of the week of the year according to the day of the week
int getCurrentWeekNumber() {
  // Get the current date
  DateTime now = DateTime.now();

  // Calculate the difference between the current date and the first day of the year
  int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

  // Calculate the week number
  int currentWeekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();

  return currentWeekNumber;
}

int getWeekNumberFromDate(DateTime date) {
  int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
  int weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();
  return weekNumber;
}

// Create an instance of a workbook and a worksheetStat
Future<void> createExcelFileStatWeekly(
    context, equipe, List<Map<String, dynamic>> listAgentData) async {
  String formattedWeek = getWeekNumberFromDate(DateTime.now()).toString();
  try {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheetStat = workbook.worksheets[0];
    sheetStat.name = "StatAgents_$formattedWeek";

    sheetStat.showGridlines = false;
    // Enable calculation for worksheet.
    sheetStat.enableSheetCalculations();
    sheetStat.pageSetup.orientation = xcel.ExcelPageOrientation.landscape;

    // Add Title to the Feuille de Route
    final xcel.Range rangeTitle = sheetStat.getRangeByName('D2:T2');
    rangeTitle.merge();
    sheetStat
        .getRangeByName('D2')
        .setText('Feuille de Route - $equipe -  Semaine : $formattedWeek');
    rangeTitle.cellStyle.fontSize = 18;
    rangeTitle.cellStyle.bold = true;
    rangeTitle.cellStyle.borders.all.lineStyle = xcel.LineStyle.double;
    rangeTitle.cellStyle.hAlign = xcel.HAlignType.center;
    rangeTitle.cellStyle.vAlign = xcel.VAlignType.center;
    rangeTitle.cellStyle.backColor = '#0D88FC';
    rangeTitle.cellStyle.fontColor = '#FFFFFF';

    // Create column headers in the first row of the Excel sheetFeuilleRoute
    sheetStat.getRangeByIndex(4, 1).setText('Agents');
    sheetStat.getRangeByName('A4:A5').merge();
    sheetStat.getRangeByName('A4').columnWidth = 10;

    //Lundi
    sheetStat.getRangeByIndex(4, 2).setText('Lundi');
    sheetStat.getRangeByName('B4:D4').merge();
    sheetStat.getRangeByName('B4:D4').columnWidth = 3.5;

    //Mardi
    sheetStat.getRangeByIndex(4, 5).setText('Mardi');
    sheetStat.getRangeByName('E4:G4').merge();
    sheetStat.getRangeByName('E4:G4').columnWidth = 3.5;

    //Mercredi
    sheetStat.getRangeByIndex(4, 8).setText('Mercredi');
    sheetStat.getRangeByName('H4:J4').merge();
    sheetStat.getRangeByName('H4:J4').columnWidth = 3.5;

    //Jeudi
    sheetStat.getRangeByIndex(4, 11).setText('Jeudi');
    sheetStat.getRangeByName('K4:M4').merge();
    sheetStat.getRangeByName('K4:M4').columnWidth = 3.5;

    //vendredi
    sheetStat.getRangeByIndex(4, 14).setText('Vendredi');
    sheetStat.getRangeByName('N4:P4').merge();
    sheetStat.getRangeByName('N4:P4').columnWidth = 3.5;

    //Samedi
    sheetStat.getRangeByIndex(4, 17).setText('Samedi');
    sheetStat.getRangeByName('Q4:S4').merge();
    sheetStat.getRangeByName('Q4:S4').columnWidth = 3.5;

    //Dimanche
    sheetStat.getRangeByIndex(4, 20).setText('Dimanche');
    sheetStat.getRangeByName('T4:V4').merge();
    sheetStat.getRangeByName('T4:V4').columnWidth = 3.5;

    // Set PV, QP, Montant headers
    for (int i = 0; i < 7; i++) {
      sheetStat.getRangeByIndex(5, i * 3 + 2).setText('PV');
      sheetStat.getRangeByIndex(5, i * 3 + 3).setText('QP');
      sheetStat.getRangeByIndex(5, i * 3 + 4).setText('€€');
    }

    // Set TOTAL header and merge
    sheetStat.getRangeByIndex(4, 23).setText('Total-S');
    sheetStat.getRangeByName('W4:Y4').merge();
    // Set PV, QP, Montant headers for TOTAL
    sheetStat.getRangeByIndex(5, 23).setText('PV');
    sheetStat.getRangeByIndex(5, 24).setText('QP');
    sheetStat.getRangeByIndex(5, 25).setText('€€');
    sheetStat.getRangeByName('W4:Y4').columnWidth = 5;

    // Set Style
    sheetStat.getRangeByName('A4:V4').cellStyle.backColor = '#0D88FC';
    sheetStat.getRangeByName('W4:Y4').cellStyle.backColor = '#800080';
    sheetStat.getRangeByName('A4:Y4').cellStyle.fontColor = '#FFFFFF';
    sheetStat.getRangeByName('A4:Y4').cellStyle.hAlign = xcel.HAlignType.center;
    sheetStat.getRangeByName('A4:A5').cellStyle.vAlign = xcel.VAlignType.center;
    sheetStat.getRangeByName('A4:Y4').cellStyle.fontSize = 14;
    sheetStat.getRangeByName('A4:Y4').cellStyle.borders.all.lineStyle =
        xcel.LineStyle.thin;
    sheetStat.getRangeByName('B5:V5').cellStyle.backColor = '#0D98BA';
    sheetStat.getRangeByName('W5:Y5').cellStyle.backColor = '#FFC300';
    sheetStat.getRangeByName('B5:V5').cellStyle.fontColor = '#FFFFFF';
    sheetStat.getRangeByName('B5:Y5').cellStyle.hAlign = xcel.HAlignType.center;
    sheetStat.getRangeByName('B5:Y5').cellStyle.fontSize = 12;
    sheetStat.getRangeByName('B5:Y5').cellStyle.borders.all.lineStyle =
        xcel.LineStyle.thin;

    var startingRowIndex = 6; // Initialize startingRowIndex outside the loop
    var lastRowIndex; // Variable to store the last row index

    int totalPVDay = 0;
    int totalQPDay = 0;
    int totalMontantDay = 0;

// Create lists to store daily totals for each column
    List<int> dailyTotalPV = List.filled(7, 0);
    List<int> dailyTotalQP = List.filled(7, 0);
    List<int> dailyTotalMontant = List.filled(7, 0);

    print(listAgentData);
    if (listAgentData.isNotEmpty) {
      for (int i = 0; i < listAgentData.length; i++) {
        String name = listAgentData[i]['name'];
        var dailyData = listAgentData[i]['data'];
         if (listAgentData[i].isNotEmpty && dailyData != null) {
        // Reset totals for each agent
        totalPVDay = 0;
        totalQPDay = 0;
        totalMontantDay = 0;

        for (var entry in dailyData) {
           String jour = entry['jour'];
            int pv = entry['pv'] as int? ?? 0;
            int qp = entry['qp'] as int? ?? 0;
            int montant = entry['montant'] as int? ?? 0;

          var lowercaseJour = jour.toLowerCase();
          var dayIndex = daysOfWeek.indexOf(lowercaseJour);

          // Update totals
          totalPVDay += pv;
          totalQPDay += qp;
          totalMontantDay += montant;
          // Update daily totals
          dailyTotalPV[dayIndex] += pv;
          dailyTotalQP[dayIndex] += qp;
          dailyTotalMontant[dayIndex] += montant;

          if (dayIndex >= 0 && dayIndex < daysOfWeek.length) {
            sheetStat.getRangeByIndex(startingRowIndex, 1).setText(name);
            sheetStat.getRangeByName('A$startingRowIndex').cellStyle.backColor =
                '#0D98BA';
            sheetStat.getRangeByName('A$startingRowIndex').cellStyle.fontColor =
                '#FFFFFF';
            sheetStat.getRangeByName('A$startingRowIndex').rowHeight = 20;

            sheetStat
                .getRangeByIndex(startingRowIndex, dayIndex * 3 + 2)
                .setText(pv.toString());

            sheetStat
                .getRangeByIndex(startingRowIndex, dayIndex * 3 + 3)
                .setText(qp.toString());
            sheetStat
                .getRangeByIndex(startingRowIndex, dayIndex * 3 + 4)
                .setText(montant.toString());
          } else {
            sheetStat.getRangeByIndex(startingRowIndex, 1).setText(name);
            sheetStat.getRangeByName('A$startingRowIndex').cellStyle.backColor =
                '#0D98BA';
            sheetStat.getRangeByName('A$startingRowIndex').cellStyle.fontColor =
                '#FFFFFF';
            sheetStat.getRangeByName('A$startingRowIndex').rowHeight = 20;

            for (var i = 0; i < daysOfWeek.length; i++) {
              if (dayIndex >= 0 && dayIndex < daysOfWeek.length) {
                sheetStat
                    .getRangeByIndex(startingRowIndex, dayIndex * 3 + 2)
                    .setText('0');
                sheetStat
                    .getRangeByIndex(startingRowIndex, dayIndex * 3 + 3)
                    .setText('0');
                sheetStat
                    .getRangeByIndex(startingRowIndex, dayIndex * 3 + 4)
                    .setText('0');
              }
            }
          }
        }
        // Update totals outside the day loop
        sheetStat
            .getRangeByIndex(startingRowIndex, 23)
            .setText(totalPVDay.toString()); // Total PV
        sheetStat
            .getRangeByIndex(startingRowIndex, 24)
            .setText(totalQPDay.toString()); // Total QP
        sheetStat
            .getRangeByIndex(startingRowIndex, 25)
            .setText(totalMontantDay.toString()); // Total Montant

        // Set the style for the entire row
        sheetStat
            .getRangeByName('A$startingRowIndex:Y$startingRowIndex')
            .cellStyle
            .hAlign = xcel.HAlignType.center;
        sheetStat
            .getRangeByName('A$startingRowIndex:Y$startingRowIndex')
            .cellStyle
            .vAlign = xcel.VAlignType.center;
        sheetStat
            .getRangeByName('A$startingRowIndex:Y$startingRowIndex')
            .cellStyle
            .fontSize = 12;
        sheetStat
            .getRangeByName('A$startingRowIndex:Y$startingRowIndex')
            .cellStyle
            .borders
            .all
            .lineStyle = xcel.LineStyle.thin;
        sheetStat.getRangeByName('D6:D$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('D6:D$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('G6:G$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('G6:G$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('J6:J$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('J6:J$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('M6:M$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('M6:M$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('P6:P$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('P6:P$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('S6:S$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('S6:S$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('V6:V$startingRowIndex').cellStyle.backColor =
            '#FFC300';
        sheetStat.getRangeByName('V6:V$startingRowIndex').cellStyle.fontColor =
            '#000000';
        sheetStat.getRangeByName('Y6:Y$startingRowIndex').cellStyle.backColor =
            '#FFC300';

        startingRowIndex++;
        lastRowIndex = startingRowIndex;
      }}
    }
// Fill out the last row with the daily totals
    sheetStat.getRangeByIndex(lastRowIndex, 1).setText('Total-J');
    for (int i = 0; i < 7; i++) {
      sheetStat
          .getRangeByIndex(lastRowIndex, i * 3 + 2)
          .setText(dailyTotalPV[i].toString());
      sheetStat
          .getRangeByIndex(lastRowIndex, i * 3 + 3)
          .setText(dailyTotalQP[i].toString());
      sheetStat
          .getRangeByIndex(lastRowIndex, i * 3 + 4)
          .setText(dailyTotalMontant[i].toString());
    }
//*******************************TOTAL********************************* */

    sheetStat.getRangeByName('A$lastRowIndex').rowHeight = 20;
    sheetStat
        .getRangeByName('A$lastRowIndex:A$lastRowIndex')
        .cellStyle
        .backColor = '#800080';
    sheetStat
        .getRangeByName('A$lastRowIndex:A$lastRowIndex')
        .cellStyle
        .fontColor = '#FFFFFF';
    sheetStat
        .getRangeByName('W$lastRowIndex:Y$lastRowIndex')
        .cellStyle
        .backColor = '#800080';
    sheetStat
        .getRangeByName('W$lastRowIndex:Y$lastRowIndex')
        .cellStyle
        .fontColor = '#FFFFFF';
    sheetStat
        .getRangeByName('A$lastRowIndex:Y$lastRowIndex')
        .cellStyle
        .borders
        .all
        .lineStyle = xcel.LineStyle.thin;
    sheetStat.getRangeByName('A$lastRowIndex:Y$lastRowIndex').cellStyle.vAlign =
        xcel.VAlignType.center;
    sheetStat.getRangeByName('A$lastRowIndex:Y$lastRowIndex').cellStyle.hAlign =
        xcel.HAlignType.center;
    sheetStat.getRangeByName('D6:D$lastRowIndex').cellStyle.backColor =
        '#FFC300';

    sheetStat.getRangeByName('D6:D$lastRowIndex').cellStyle.fontColor =
        '#000000';
    sheetStat.getRangeByName('G6:G$lastRowIndex').cellStyle.backColor =
        '#FFC300';
    sheetStat.getRangeByName('G6:G$lastRowIndex').cellStyle.fontColor =
        '#000000';
    sheetStat.getRangeByName('J6:J$lastRowIndex').cellStyle.backColor =
        '#FFC300';
    sheetStat.getRangeByName('J6:J$lastRowIndex').cellStyle.fontColor =
        '#000000';
    sheetStat.getRangeByName('M6:M$lastRowIndex').cellStyle.backColor =
        '#FFC300';
    sheetStat.getRangeByName('M6:M$lastRowIndex').cellStyle.fontColor =
        '#000000';
    sheetStat.getRangeByName('P6:P$lastRowIndex').cellStyle.backColor =
        '#FFC300';
    sheetStat.getRangeByName('P6:P$lastRowIndex').cellStyle.fontColor =
        '#000000';
    sheetStat.getRangeByName('S6:S$lastRowIndex').cellStyle.backColor =
        '#FFC300';
    sheetStat.getRangeByName('S6:S$lastRowIndex').cellStyle.fontColor =
        '#000000';
    sheetStat.getRangeByName('V6:V$lastRowIndex').cellStyle.backColor =
        '#FFC300';
    sheetStat.getRangeByName('V6:V$lastRowIndex').cellStyle.fontColor =
        '#000000';

//Total for the all the agents for all the week
    num sumPvSemaine = 0;
    num sumQpSemaine = 0;
    num sumMontantSemaine = 0;

    for (var agent in listAgentData) {
      sumPvSemaine += (agent["pvSemaine"] ?? 0) as num;
      sumQpSemaine += (agent["qpSemaine"] ?? 0) as num;
      sumMontantSemaine += (agent["montantSemaine"] ?? 0) as num;
    }

    sheetStat.getRangeByName('W$lastRowIndex').setText(sumPvSemaine.toString());
    sheetStat.getRangeByName('X$lastRowIndex').setText(sumQpSemaine.toString());
    sheetStat
        .getRangeByName('Y$lastRowIndex')
        .setText(sumMontantSemaine.toString());

    //============================ create and save the fille =================

    // Save the workbook to a byte array
    final List<int> bytes = workbook.saveAsStream();

    // Get the downloads directory path
    final String? downloadsDirectoryPath =
        (await getDownloadsDirectory())?.path;

    if (downloadsDirectoryPath != null) {
      // Define the file name
      String excelFileName = '$equipe.statAgents_$formattedWeek.xlsx';
      // Create the full file path by joining the downloads directory path and the file name
      final String filePath = '$downloadsDirectoryPath/$excelFileName';
      print(filePath);
      final File file = File(filePath);
      await file.writeAsBytes(bytes);
      // Dispose of the workbook created
      workbook.dispose();
    }
  } catch (e) {
    print("une erreur s'est produite : $e");
  }
}
