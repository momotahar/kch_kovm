// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

// Create an instance of a workbook and a worksheetFeuilleRoute
Future<void> createExcelFileFeuilleRoute(
    BuildContext context,
    String equipe,
    List<List<dynamic>> feuilleRoute,
    String priseService,
    String depart,
    String pause,
    String finService,
    String observations) async {
  try {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheetFeuilleRoute = workbook.worksheets[0];
    final xcel.Worksheet sheetPriseService = workbook.worksheets.add();
    sheetFeuilleRoute.name = "FeuilleRoute_$formattedDate";
    sheetPriseService.name = "PriseService_$formattedDate";

    sheetFeuilleRoute.showGridlines = false;
    sheetPriseService.showGridlines = false;

    // Enable calculation for worksheet.
    sheetFeuilleRoute.enableSheetCalculations();
    sheetPriseService.enableSheetCalculations();

    sheetFeuilleRoute.pageSetup.orientation =
        xcel.ExcelPageOrientation.landscape;
    //============================ START FEUILLE DE ROUTE =================
    // Add Title to the Feuille de Route
    final xcel.Range rangeTitle = sheetFeuilleRoute.getRangeByName('C2:G2');
    rangeTitle.merge();
    sheetFeuilleRoute
        .getRangeByName('C2')
        .setText('Feuille de Route - $equipe -  Pour le : $formattedDate');
    rangeTitle.cellStyle.fontSize = 18;
    rangeTitle.cellStyle.bold = true;
    rangeTitle.cellStyle.borders.all.lineStyle = xcel.LineStyle.double;
    rangeTitle.cellStyle.hAlign = xcel.HAlignType.center;
    rangeTitle.cellStyle.vAlign = xcel.VAlignType.center;
    rangeTitle.cellStyle.backColor = '#0D88FC';
    rangeTitle.cellStyle.fontColor = '#FFFFFF';
    //Set style in the worksheetFeuilleRoute.
    sheetFeuilleRoute.getRangeByName('A5').columnWidth = 8;
    sheetFeuilleRoute.getRangeByName('B5').columnWidth = 9;
    sheetFeuilleRoute.getRangeByName('C5').columnWidth = 10.5;
    sheetFeuilleRoute.getRangeByName('D5').columnWidth = 32;
    sheetFeuilleRoute.getRangeByName('E5').columnWidth = 6.5;
    sheetFeuilleRoute.getRangeByName('F5').columnWidth = 32;
    sheetFeuilleRoute.getRangeByName('G5').columnWidth = 6.5;
    sheetFeuilleRoute.getRangeByName('H5').columnWidth = 7;
    sheetFeuilleRoute.getRangeByName('I5').columnWidth = 6;
    //-set style
    sheetFeuilleRoute.getRangeByName('A5:I5').cellStyle.backColor = '#0D88FC';
    sheetFeuilleRoute.getRangeByName('A5:I5').cellStyle.fontColor = '#FFFFFF';
    sheetFeuilleRoute.getRangeByName('A5:I5').cellStyle.hAlign =
        xcel.HAlignType.center;
    sheetFeuilleRoute.getRangeByName('A5:I5').cellStyle.vAlign =
        xcel.VAlignType.center;
    sheetFeuilleRoute.getRangeByName('A5:I5').cellStyle.fontSize = 14;
    sheetFeuilleRoute.getRangeByName('A5:I5').cellStyle.borders.all.lineStyle =
        xcel.LineStyle.thin;
    //-Create column headers in the 5th row for the Feuille de Route
    sheetFeuilleRoute.getRangeByIndex(5, 1).setText('Ligne');
    sheetFeuilleRoute.getRangeByIndex(5, 2).setText('service');
    sheetFeuilleRoute.getRangeByIndex(5, 3).setText('Bus/Tram');
    sheetFeuilleRoute.getRangeByIndex(5, 4).setText('Montée');
    sheetFeuilleRoute.getRangeByIndex(5, 5).setText('H-M');
    sheetFeuilleRoute.getRangeByIndex(5, 6).setText('Descente');
    sheetFeuilleRoute.getRangeByIndex(5, 7).setText('H-D');
    sheetFeuilleRoute.getRangeByIndex(5, 8).setText('Nb-vg');
    sheetFeuilleRoute.getRangeByIndex(5, 9).setText('Pv');

    // Insert data into the Excel sheetFeuilleRoute
    for (var rowIndex = 0; rowIndex < feuilleRoute.length; rowIndex++) {
      final item = feuilleRoute[rowIndex];
      for (var columnIndex = 0; columnIndex < item.length; columnIndex++) {
        sheetFeuilleRoute
            .getRangeByIndex(rowIndex + 6, columnIndex + 1)
            .setText(item[columnIndex].toString());
        sheetFeuilleRoute
            .getRangeByIndex(rowIndex + 6, columnIndex + 1)
            .cellStyle
            .fontSize = 12;
        sheetFeuilleRoute
            .getRangeByIndex(rowIndex + 6, columnIndex + 1)
            .cellStyle
            .borders
            .all
            .lineStyle = xcel.LineStyle.thin;
      }
    }
    //============================ END FEUILLE DE ROUTE ===================

    //============================ START PRISE DE SERVICE =================
    // Add Title to the Feuille de Route
    final xcel.Range rangeTitlePs = sheetPriseService.getRangeByName('A2:G2');
    rangeTitlePs.merge();
    sheetPriseService
        .getRangeByName('A2')
        .setText('Prise de Service - $equipe -  Pour le : $formattedDate');
    rangeTitlePs.cellStyle.fontSize = 18;
    rangeTitlePs.cellStyle.bold = true;
    rangeTitlePs.cellStyle.borders.all.lineStyle = xcel.LineStyle.double;
    rangeTitlePs.cellStyle.hAlign = xcel.HAlignType.center;
    rangeTitlePs.cellStyle.vAlign = xcel.VAlignType.center;
    rangeTitlePs.cellStyle.backColor = '#0D88FC';
    rangeTitlePs.cellStyle.fontColor = '#FFFFFF';
    //Set style in the worksheetFeuilleRoute.
    sheetPriseService.getRangeByName('A5').columnWidth = 15;
    sheetPriseService.getRangeByName('B5').columnWidth = 15;
    sheetPriseService.getRangeByName('C5').columnWidth = 8;
    sheetPriseService.getRangeByName('D5').columnWidth = 15;
    final xcel.Range rangeObservations =
        sheetPriseService.getRangeByName('A8:G8');
    rangeObservations.merge();
    rangeObservations.cellStyle.fontSize = 14;
    rangeObservations.cellStyle.bold = true;
    rangeObservations.cellStyle.borders.all.lineStyle = xcel.LineStyle.double;
    rangeObservations.cellStyle.hAlign = xcel.HAlignType.center;
    rangeObservations.cellStyle.vAlign = xcel.VAlignType.center;
    rangeObservations.cellStyle.backColor = '#0D88FC';
    rangeObservations.cellStyle.fontColor = '#FFFFFF';
    final xcel.Range rangeObservationsText =
        sheetPriseService.getRangeByName('A9:G22');
    rangeObservationsText.merge();
    rangeObservationsText.cellStyle.fontSize = 12;
    rangeObservationsText.cellStyle.wrapText = true;
    rangeObservationsText.cellStyle.borders.all.lineStyle =
        xcel.LineStyle.double;
    // rangeObservationsText.cellStyle.hAlign = xcel.HAlignType.center;
    rangeObservationsText.cellStyle.vAlign = xcel.VAlignType.center;
    //-set style
    sheetPriseService.getRangeByName('A5:D5').cellStyle.backColor = '#0D88FC';
    sheetPriseService.getRangeByName('A5:D5').cellStyle.fontColor = '#FFFFFF';
    sheetPriseService.getRangeByName('A5:D5').cellStyle.hAlign =
        xcel.HAlignType.center;
    sheetPriseService.getRangeByName('A5:D5').cellStyle.vAlign =
        xcel.VAlignType.center;
    sheetPriseService.getRangeByName('A5:D5').cellStyle.fontSize = 14;
    sheetPriseService.getRangeByName('A5:D5').cellStyle.borders.all.lineStyle =
        xcel.LineStyle.thin;
    //-Create column headers in the 5th row for the Feuille de Route
    sheetPriseService.getRangeByIndex(5, 1).setText('Prise Service');
    sheetPriseService.getRangeByIndex(5, 2).setText('Départ Dépôt');
    sheetPriseService.getRangeByIndex(5, 3).setText('Pause');
    sheetPriseService.getRangeByIndex(5, 4).setText('Fin Service');
    sheetPriseService.getRangeByName('A8').setText('Observations');
    //-fill out the data in the rows
    sheetPriseService.getRangeByIndex(6, 1).setText(priseService);
    sheetPriseService.getRangeByIndex(6, 2).setText(depart);
    sheetPriseService.getRangeByIndex(6, 3).setText(pause);
    sheetPriseService.getRangeByIndex(6, 4).setText(finService);
    sheetPriseService.getRangeByName('A9').setText(observations);
    //-style

    sheetPriseService.getRangeByName('A6:D6').cellStyle.fontSize = 12;
    sheetPriseService.getRangeByName('A6:D6').cellStyle.borders.all.lineStyle =
        xcel.LineStyle.thin;
    sheetPriseService.getRangeByName('A6:D6').cellStyle.hAlign =
        xcel.HAlignType.center;
    sheetPriseService.getRangeByName('A6:D6').cellStyle.vAlign =
        xcel.VAlignType.center;
    //============================ End PRISE DE SERVICE =================
    //============================ create and save the fille =================

    // Save the workbook to a byte array
    final List<int> bytes = workbook.saveAsStream();

    // Get the downloads directory path
    final String? downloadsDirectoryPath =
        (await getDownloadsDirectory())?.path;
   

    if (downloadsDirectoryPath != null) {
      // Define the file name
      String excelFileName = '$equipe.feuilleRoute_$formattedDate.xlsx';
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
