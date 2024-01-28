// ignore_for_file: avoid_print

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

// Create an instance of a workbook and a worksheetFeuilleRoute
Future<void> createExcelFileStatBusTram(context,equipe, statics) async {
  try {
    String formattedMois = DateFormat('MM-yyyy').format(DateTime.now());

    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheetStatBusTram = workbook.worksheets[0];
    sheetStatBusTram.name = "StatBusTram_$formattedMois";

    sheetStatBusTram.showGridlines = false;
    // Enable calculation for worksheet.
    sheetStatBusTram.enableSheetCalculations();

    // Add Title to the Feuille de Route
    final xcel.Range rangeTitle = sheetStatBusTram.getRangeByName('B1:F1');
    rangeTitle.merge();
    sheetStatBusTram
        .getRangeByName('B1')
        .setText('Stat Bus-Tram : $equipe -  Mois : $formattedMois');
    rangeTitle.cellStyle.fontSize = 15;
    rangeTitle.cellStyle.bold = true;
    rangeTitle.cellStyle.borders.all.lineStyle = xcel.LineStyle.double;
    rangeTitle.cellStyle.hAlign = xcel.HAlignType.center;
    rangeTitle.cellStyle.vAlign = xcel.VAlignType.center;
    rangeTitle.cellStyle.backColor = '#0D88FC';
    rangeTitle.cellStyle.fontColor = '#FFFFFF';

    // Headers
    List busTram = ['T9', '483', '482', '480', '282', 'Licorne'];
    List objectif = [13000, 2000, 150, 250, 100, 15];
    for (var i = 0; i < busTram.length; i++) {
      sheetStatBusTram.getRangeByIndex(3, i + 2).setText(busTram[i]);
      sheetStatBusTram
          .getRangeByIndex(37, i + 2)
          .setText(objectif[i].toString());
    }
    sheetStatBusTram.getRangeByIndex(3, 1).setText('Jours');
    sheetStatBusTram.getRangeByName('A3').columnWidth = 10;
    sheetStatBusTram.getRangeByName('A3').cellStyle.backColor = '#800080';
    sheetStatBusTram.getRangeByName('A3').cellStyle.fontColor = '#FFFFFF';

    // Total Rows
    sheetStatBusTram.getRangeByIndex(35, 1).setText('Réalisé');
    sheetStatBusTram.getRangeByIndex(36, 1).setText('Ecart');
    sheetStatBusTram.getRangeByIndex(37, 1).setText('Objectifs');
    sheetStatBusTram.getRangeByName('A35:A37').cellStyle.backColor = '#800080';
    sheetStatBusTram.getRangeByName('A35:A37').cellStyle.fontColor = '#FFFFFF';
    // Set Style
    sheetStatBusTram.getRangeByName('B3:G3').columnWidth = 10;
    sheetStatBusTram.getRangeByName('B3:G3').cellStyle.backColor = '#0D88FC';
    sheetStatBusTram.getRangeByName('B3:G3').cellStyle.fontColor = '#FFFFFF';
    sheetStatBusTram.getRangeByName('A3:G37').cellStyle.fontSize = 15;
    sheetStatBusTram.getRangeByName('B3:G37').cellStyle.hAlign =
        xcel.HAlignType.center;
    sheetStatBusTram.getRangeByName('B3:G37').cellStyle.vAlign =
        xcel.VAlignType.center;
    sheetStatBusTram.getRangeByName('A3:G37').cellStyle.borders.all.lineStyle =
        xcel.LineStyle.thin;

    // Fill out the first column with days of the current month
    var currentDate = DateTime.now();
    for (var rowIndex = 0; rowIndex < 31; rowIndex++) {
      var currentRowIndex = rowIndex + 4;
      var dayOfMonth =
          DateTime(currentDate.year, currentDate.month, rowIndex + 1);
      String formattedDayOfMonth = DateFormat('dd-MMM').format(dayOfMonth);
      sheetStatBusTram
          .getRangeByName('A$currentRowIndex')
          .setText(formattedDayOfMonth);
      sheetStatBusTram.getRangeByIndex(currentRowIndex, 1).cellStyle.backColor =
          '#0D88FC';
      sheetStatBusTram.getRangeByIndex(currentRowIndex, 1).cellStyle.fontColor =
          '#FFFFFF';
      if (statics != null) {
        for (var data in statics) {
          // Extract values from data
          var dateJour = data['dateJour'];
          var ligne = data['ligne'];

          // Parse the date string to a DateTime object
          var dateParts = dateJour.split('-');
          var day = int.parse(dateParts[0]);
          var month = int.parse(dateParts[1]);
          var year = int.parse(dateParts[2]);
          var dataDate = DateTime(year, month, day);

          // Check if the data is related to the current month
          var currentDate = DateTime.now();
          if (dataDate.month == currentDate.month) {
            // Find the corresponding column index for the ligne
            var columnIndex = busTram.indexOf(ligne);

            // Check if ligne matches the column
            if (columnIndex != -1) {
              // Update the corresponding cells
              sheetStatBusTram
                  .getRangeByIndex(day + 3, columnIndex + 2)
                  .setText(data['voyageursTotal'].toString());

            }
          }
        }
      }

      // Calculate the sum for each column
      for (var columnIndex = 0; columnIndex < busTram.length; columnIndex++) {
        int sumDonne = 0;
        num sumLeft = 0;
        for (var innerRowIndex = 0; innerRowIndex < 31; innerRowIndex++) {
          var cellValue = sheetStatBusTram
              .getRangeByIndex(innerRowIndex + 4, columnIndex + 2)
              .getText();
          if (cellValue != null && cellValue.isNotEmpty) {
            sumDonne += int.parse(cellValue);
          }
        }
        sumLeft = sumDonne - objectif[columnIndex];
        sheetStatBusTram.getRangeByName('B35:G35').cellStyle.fontColor =
            '#008000';
        sheetStatBusTram.getRangeByName('B36:G36').cellStyle.fontColor =
            '#FF0000';

        // Set the sum in the last row for each column
        sheetStatBusTram
            .getRangeByIndex(35, columnIndex + 2)
            .setText(sumDonne.toString());
        sheetStatBusTram
            .getRangeByIndex(36, columnIndex + 2)
            .setText(sumLeft.toString());
      }
    }

    // Save and dispose of the workbook
    final List<int> bytes = workbook.saveAsStream();
    final String? downloadsDirectoryPath =
        (await getDownloadsDirectory())?.path;

    if (downloadsDirectoryPath != null) {
      String excelFileName = '$equipe.statBusTram_$formattedMois.xlsx';
      final String filePath = '$downloadsDirectoryPath/$excelFileName';
      print(filePath);
      final File file = File(filePath);

      await file.writeAsBytes(bytes);
    }

    workbook.dispose();
  } catch (e) {
    print("une erreur s'est produite : $e");
  }
}
