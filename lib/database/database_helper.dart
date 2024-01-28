// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kch_kovm/excel/stat_weekly.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String lignesTable = 'lignes';
  String columnId = 'id';
  String columnLigne = 'ligne';
  String columnService = 'service';
  String columnBusTram = 'busTram';
  String columnMontee = 'montee';
  String columnHeureMontee = 'heureMontee';
  String columnDescente = 'descente';
  String columnHeureDescente = 'heureDescente';
  String columnVoyageurs = 'voyageurs';
  String columnPv = 'pv';
  String columnDateJour = 'dateJour';
  //=================================
  String agentsTable = 'agents';
  String columnAgentId = 'id';
  String columnName = 'name';
  String columnSurname = 'surname';
  String columnMatricule = 'matricule';
//=====================================
  String statAgentsTable = 'statAgents';
  String columnStatAgentId = 'id';
  String columnAgentPv = 'pv';
  String columnAgentQp = 'qp';
  String columnAgentMontant = 'montant';
  String columnWeekNumber = 'week';
  String columnJour = 'jour';
  //====================================
  String priseServiceTable = 'priseServiceTable';
  String columnPriseServiceId = 'priseServiceId';
  String columnPriseService = 'priseService';
  String columnEquipe = 'equipe';
  String columnDepart = 'depart';
  String columnPause = 'pause';
  String columnFinService = 'finService';
  String columnObservation = 'observations';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }
  Future<Database?> initializeDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'kch_sqlite.db');
      return await openDatabase(path, version: 1, onCreate: _createDb);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Database> get database async {
    try {
      _database ??= await initializeDatabase();
      return _database!;
    } catch (e) {
      throw Exception(e);
    }
  }

  void _createDb(Database db, int newVersion) async {
    try {
      await db.execute('''CREATE TABLE $lignesTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnLigne TEXT,
      $columnService TEXT,
      $columnBusTram TEXT,
      $columnMontee TEXT,
      $columnHeureMontee TEXT,
      $columnDescente TEXT,
      $columnHeureDescente TEXT,
      $columnVoyageurs INTEGER,
      $columnPv INTEGER,
      $columnDateJour TEXT
    )
  ''');
      await db.execute('''CREATE TABLE  $agentsTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT,
      $columnSurname TEXT,
      $columnMatricule TEXT UNIQUE,
      UNIQUE($columnMatricule, $columnName)

    )
  ''');
      await db.execute('''CREATE TABLE  $statAgentsTable (
      $columnStatAgentId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnMatricule TEXT,
      $columnName TEXT,
      $columnSurname TEXT,
      $columnAgentPv INTEGER,
      $columnAgentQp INTEGER,
      $columnAgentMontant INTEGER,
      $columnWeekNumber INTEGER,
      $columnDateJour TEXT,
      $columnJour TEXT,
      UNIQUE($columnMatricule, $columnDateJour)
    )
  ''');
      await db.execute('''CREATE TABLE  $priseServiceTable (
      $columnPriseServiceId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnEquipe TEXT,
      $columnPriseService TEXT,
      $columnDepart TEXT,
      $columnPause TEXT,
      $columnFinService INTEGER,
      $columnObservation INTEGER,
      $columnDateJour TEXT
    )
  ''');
    } catch (e) {
      throw Exception(e);
    }
  }

//==========================================================
//================= CRUD Prise de service Rapport===========
//Insert new rapport prise de service
  Future<int?> newRapportPriseService(
      Map<String, dynamic> row, BuildContext context) async {
    try {
      Database db = await database;
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // Check if a record with the current date already exists
      List<Map<String, dynamic>> existingRecords = await db.query(
        priseServiceTable,
        where: '$columnDateJour = ?',
        whereArgs: [currentDate],
      );

      if (existingRecords.isEmpty) {
        return await db.insert(priseServiceTable, row);
      } else {
        print('Vous avez déjà enregistrer une prise de service');

        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //fetch rapport prise de service for the current date
  Future<List<Map<String, Object?>>?> getRapportForCurrentDate() async {
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      Database db = await database;

      var rapportPriseService = await db.query(
        priseServiceTable,
        where: '$columnDateJour = ?',
        whereArgs: [currentDate],
      );
      return rapportPriseService;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Update rapport prise de service
  Future<int?> updatePriseServiceByDate(
      String dateJour, Map<String, dynamic> newData) async {
    try {
      Database db = await database;
      return await db.update(
        priseServiceTable,
        newData,
        where: '$columnDateJour = ?',
        whereArgs: [dateJour],
      );
    } catch (e) {
      return null;
    }
  }

//===========================================================
//============================ CRUD LIGNES =================
//Insert new ligne
  Future<int?> insert(Map<String, dynamic> row) async {
    try {
      Database db = await database;
      return await db.insert(lignesTable, row);
    } catch (e) {
      throw Exception(e);
    }
  }

//fetch all lignes for the current date
  Future<List<Map<String, dynamic>>?> getLignesForCurrentDate() async {
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      Database db = await database;

      var listOfLignes = await db.query(
        lignesTable,
        where: '$columnDateJour = ?',
        whereArgs: [currentDate],
        orderBy: '$columnId DESC',
      );
      return listOfLignes;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Update Ligne for descente
  Future<int?> updateLigneById(int id, Map<String, dynamic> newData) async {
    try {
      Database db = await database;
      return await db.update(
        lignesTable,
        newData,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  // Delete Ligne by ID
  Future<int?> deleteLigneById(int id) async {
    try {
      Database db = await database;
      return await db.delete(
        lignesTable,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

//Get stats by day
  Future<List<Map<String, dynamic>>> getStatsForEachLigneOnCurrentDate() async {
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      Database db = await database;

      List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT
      ligne,
      dateJour,
      COUNT(*) as totalCount,
      SUM(pv) as totalPvSum,
      SUM(voyageurs) as totalVoyageursSum
    FROM $lignesTable
    WHERE dateJour = ? 
    GROUP BY ligne, dateJour
  ''', [currentDate]);

      // The result is a list of maps, each containing counts for a specific 'ligne'.
      List<Map<String, dynamic>> countsList = result.map((row) {
        return {
          'ligne': row['ligne'],
          'dateJour': row['dateJour'],
          'week': row['week'],
          'totalCount': row['totalCount'] ?? 0,
          'totalVoyageursSum': row['totalVoyageursSum'] ?? 0,
          'totalPvSum': row['totalPvSum'] ?? 0,
        };
      }).toList();

      return countsList;
    } catch (e) {
      throw Exception(e);
    }
  }

//Get stats by Month
  Future<List<Map<String, dynamic>>> getSummaryForCurrentMonth() async {
      String currentMonth = DateFormat('MM').format(DateTime.now());
      String currentYear = DateFormat('yyyy').format(DateTime.now());
    try {
      Database db = await database;
      // Get the current month and year.

      List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT
      ligne,
      dateJour,
      COUNT(*) as totalCount,
      SUM(pv) as totalPvSum,
      SUM(voyageurs) as totalVoyageursSum
    FROM $lignesTable
    WHERE SUBSTR(dateJour, 4, 2) = ? 
      AND SUBSTR(dateJour, 7, 4) = ? 
    GROUP BY ligne
  ''', [currentMonth, currentYear]);

      // The result is a list of maps, each containing counts for a specific 'ligne'.
      List<Map<String, dynamic>> countsList = result.map((row) {
        return {
          'ligne': row['ligne'],
          'dateJour': row['dateJour'],
          'totalCount': row['totalCount'] ?? 0,
          'totalVoyageursSum': row['totalVoyageursSum'] ?? 0,
          'totalPvSum': row['totalPvSum'] ?? 0,
        };
      }).toList();

      return countsList;
    } catch (e) {
      throw Exception(e);
    }
  }

//==========================================================
//============================ CRUD AGENT ==================
// /Insert new ligne
  Future<int?> newAgent(Map<String, dynamic> row) async {
    try {
      Database db = await database;
      return await db.insert(agentsTable, row);
    } catch (e) {
      throw Exception('Error inserting data: $e');
    }
  }

// fetch all lignes for the current date
  Future<List<Map<String, dynamic>>?> getAllAgents() async {
    try {
      Database db = await database;

      var listOfAgents = await db.query(agentsTable);
      return listOfAgents;
    } catch (e) {
      throw Exception(e);
    }
  }

//Update Agent by ID
  Future<int?> updateAgentById(int id, Map<String, dynamic> newData) async {
    try {
      Database db = await database;
      return await db.update(
        agentsTable,
        newData,
        where: '$columnAgentId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  // Delete Agent by ID
  Future<int?> deleteAgentById(int id) async {
    try {
      Database db = await database;
      return await db.delete(
        agentsTable,
        where: '$columnAgentId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

//==========================================================
//============================ CRUD STAT AGENT =============
// /Insert new Stat agent
  Future<int?> newStatAgent(Map<String, dynamic> row) async {
    try {
      Database db = await database;
      return await db.insert(statAgentsTable, row);
    } catch (e) {
      throw Exception('Error inserting data: $e');
    }
  }

//Update stat Agent
  Future<int?> updateStatAgentById(int id, Map<String, dynamic> newData) async {
    try {
      Database db = await database;
      return await db.update(
        statAgentsTable,
        newData,
        where: '$columnAgentId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

//**********************************************************************/
//check if the stat of the agent for the current day is stored
  Future<bool> checkStatAgent(matricule, dateJour, context) async {
    try {
      Database db = await database;
      var existingRecord = await db.query(statAgentsTable,
          where: 'matricule = ? AND dateJour = ?',
          whereArgs: [matricule, dateJour]);
      if (existingRecord.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

// fetch list of agents with their stats
  Future<List<Map<String, dynamic>>?> getAllStatAgents() async {
    try {
      Database db = await database;

      var listOfStatAgents = await db.query(
        statAgentsTable,
      );
      if (listOfStatAgents.isNotEmpty) {
        int? currentWeekNumber = getCurrentWeekNumber();

        List<Map<String, dynamic>> filteredList = listOfStatAgents
            .where((stat) => stat['week'] == currentWeekNumber)
            .toList();

        Map<String, Map<String, dynamic>> groupedData = {};
        for (var agent in filteredList) {
          String key = "${agent["name"]} ${agent["surname"]}";

          if (!groupedData.containsKey(key)) {
            groupedData[key] = {
              "name": agent["name"],
              "surname": agent["surname"],
              "pvSemaine": 0,
              "qpSemaine": 0,
              "montantSemaine": 0,
              "matricule": agent["matricule"],
              "week": agent["week"],
              "data": [],
            };
          }

          groupedData[key]?["pvSemaine"] += agent["pv"];
          groupedData[key]?["qpSemaine"] += agent["qp"];
          groupedData[key]?["montantSemaine"] += agent["montant"];

          groupedData[key]?["data"].add({
            "id": agent["id"],
            "pv": agent["pv"],
            "qp": agent["qp"],
            "montant": agent["montant"],
            "dateJour": agent["dateJour"],
            "jour": agent["jour"],
          });
        }
        List<Map<String, dynamic>> finalData = groupedData.values.toList();
        return finalData;
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  //Function to get the current week number
  int? getWeekNumberFromCurrentDate() {
      DateTime now = DateTime.now();
    try {
      // Get the current date
      // Calculate the difference between the current date and the first day of the year
      int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      // Calculate the week number
      int weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
      return weekNumber;
    } catch (e) {
      throw Exception(e);
    }
  }

  int? getWeekNumberFromDateJour(String dateJour) {
      // Parse the string into a DateTime object
      DateTime dateTime = DateFormat('dd-MM-yyyy').parseStrict(dateJour);
    try {

      // Calculate the week number based on the day of the year
      int dayOfYear =
          dateTime.difference(DateTime(dateTime.year, 1, 1)).inDays + 1;
      int weekNumberFromGivenDate =
          ((dayOfYear - dateTime.weekday + 10) / 7).floor();

      return weekNumberFromGivenDate;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Clean tables
  Future<void> cleanTable() async {
    try {
      final Database db = await database;
      await db.delete(lignesTable);
      await db.delete(statAgentsTable);
      await db.delete(priseServiceTable);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> cleanTableForPreviousMonth() async {
    try {
      final Database db = await database;

      // Calculate the first day of the previous month
      DateTime now = DateTime.now();
      DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);

      // Format the date to match the dateJour column format in the database
      String formattedDate =
          "${firstDayOfPreviousMonth.year}-${firstDayOfPreviousMonth.month.toString().padLeft(2, '0')}-01";

      // Delete records where dateJour is in the previous month
      await db.delete(
        lignesTable,
        where: 'dateJour < ?',
        whereArgs: [formattedDate],
      );
      await db.delete(
        statAgentsTable,
        where: 'dateJour < ?',
        whereArgs: [formattedDate],
      );
      await db.delete(
        priseServiceTable,
        where: 'dateJour < ?',
        whereArgs: [formattedDate],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

//Get each team daily bus/tram statics
  Future<List<Map<String, dynamic>>> statEachTeamDaily() async {
    try {
      Database db = await database;

      List<Map<String, dynamic>> stats = await db.rawQuery('''
        SELECT
          id,
          ligne,
          dateJour,
          SUM(pv) AS pvTotal,
          SUM(voyageurs) AS voyageursTotal,
          COUNT(*) AS count
        FROM $lignesTable
        GROUP BY ligne, dateJour
        ORDER BY dateJour DESC
      ''');
      return stats;
    } catch (e) {
      throw Exception(e);
    }
  }
}
