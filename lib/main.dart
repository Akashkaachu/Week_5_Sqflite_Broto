import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wk5/database/databasesqflite.dart';
import 'package:wk5/Screen/save.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  await createStudentTable();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FrtPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
