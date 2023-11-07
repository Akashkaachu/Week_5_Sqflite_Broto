import 'dart:io';

import 'package:flutter/material.dart';

import 'package:wk5/Screen/updatestudent.dart';
import 'package:wk5/database/databasesqflite.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

final searchController = TextEditingController();
late List<Map<String, dynamic>> studentData = [];

class _SearchPageState extends State<SearchPage> {
  Future<void> fetchStudentData() async {
    List<Map<String, dynamic>> student = await getAllstudentDataFromDB();
    if (searchController.text.isNotEmpty) {
      student = student
          .where((s) => s['studentname']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      studentData = student;
    });
  }

  @override
  void initState() {
    fetchStudentData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.red, Colors.blue])),
          ),
          title: Center(
              child: Column(
            children: [
              Text("LIST OF STUDENTS "),
            ],
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: searchController,
              onChanged: (value) {
                fetchStudentData();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Search..."),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            studentData.isEmpty
                ? Text("Student Data is not available")
                : Expanded(
                    child: ListView.separated(
                    itemBuilder: (context, index) {
                      final student = studentData[index];
                      final id = student["id"];
                      final imageurl = student["imagesrc"];
                      final name = student["studentname"];
                      return ListTile(
                        title: Text(name),
                        subtitle: Text(id.toString()),
                        leading: CircleAvatar(
                            backgroundImage: FileImage(File(imageurl))),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UpdateStudentDetails(
                                        id: id,
                                        name: name,
                                        roll: student['roll'],
                                        department: student['department'],
                                        imagesrc: imageurl,
                                        number: student['number']),
                                  ));
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Delete The Student Information"),
                                          content: Text(
                                              "Are you sure you want to delete?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel")),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await deleteStudentDetailsFromDB(
                                                      id);
                                                  Navigator.of(context).pop();
                                                  snackBarFunction(
                                                      context,
                                                      "successfully Deleted Student Details",
                                                      Colors.green);

                                                  fetchStudentData();
                                                },
                                                child: Text("Ok"))
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      );
                    },
                    itemCount: studentData.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  )),
          ]),
        ),
      ),
    );
  }
}

final searchTextEditingControl = TextEditingController();

void snackBarFunction(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}
