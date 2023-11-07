import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wk5/Screen/search.dart';
import 'package:wk5/Screen/studentmodel.dart';

late Database _database;
Future<void> initializeDatabase() async {
  _database = await openDatabase(
    "student.db",
    version: 2,
    onCreate: (Database database, int version) async {
      await database.execute(
          'CREATE TABLE studenttable (id INTEGER PRIMARY KEY, studentname TEXT, roll INTEGER, department TEXT, number REAL, imagesrc TEXT)');
    },
    onUpgrade: (_database, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await _database.execute(
            'CREATE TABLE studenttable1 (id INTEGER PRIMARY KEY, studentname TEXT, roll INTEGER, department TEXT, number REAL, imagesrc TEXT,Address TEXT )');
      }
    },
  );
}

Future<void> addStudentToDB(StudentModel value, BuildContext context) async {
  final existingRecord = await _database.query(
    'studenttable', // Make sure the table name matches your table name
    where: 'id = ?',
    whereArgs: [value.id],
  );
  if (existingRecord.isEmpty) {
    await _database.rawInsert(
        "INSERT INTO studenttable(id, studentname, roll, department, number, imagesrc) VALUES(?,?,?,?,?,?)",
        [
          value.id,
          value.name,
          value.roll,
          value.department,
          value.number,
          value.imageurl
        ]);
    snackBarFunction(
        context, "The Student Details are uploaded successfully", Colors.green);
  } else {
    snackBarFunction(
        context, "The Student Id is also present in the database", Colors.red);
  }
}

Future<void> createStudentTable() async {
  await _database.execute(
      'CREATE TABLE IF NOT EXISTS studenttable(id INTEGER PRIMARY KEY, studentname TEXT, roll INTEGER, department TEXT, number REAL, imagesrc TEXT)');
}

Future<List<Map<String, dynamic>>> getAllstudentDataFromDB() async {
  final value = await _database.rawQuery("SELECT * FROM studenttable");
  return value;
}

Future<void> deleteStudentDetailsFromDB(int id) async {
  await _database.rawDelete('DELETE FROM studenttable WHERE id = ?', [id]);
}

Future<void> updateStudentDetailsFromDB(StudentModel updatedStudent) async {
  final updateData = await _database.update(
      "studenttable",
      {
        'id': updatedStudent.id,
        'studentname': updatedStudent.name,
        'roll': updatedStudent.roll,
        "department": updatedStudent.department,
        'number': updatedStudent.number,
        'imagesrc': updatedStudent.imageurl
      },
      where: 'id=?',
      whereArgs: [updatedStudent.id]);
}
