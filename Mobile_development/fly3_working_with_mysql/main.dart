import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

Future createTable() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'students.yss.su',
      port: 3306,
      user: 'iu9mobile',
      db: 'iu9mobile',
      password: 'bmstubmstu123'));
  await conn.query(
      'CREATE TABLE IF NOT EXISTS Samokhvalova(name char(30), email char(30), age int)');
  await conn.close();
}

Future insertToDB(name, email, age) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'students.yss.su',
      port: 3306,
      user: 'iu9mobile',
      db: 'iu9mobile',
      password: 'bmstubmstu123'));
  await conn.query(
      'INSERT INTO Samokhvalova (name, email, age) values (?, ?, ?)',
      [name, email, age]);
  await conn.close();
}

Future<String> selectFromDB() async {
  String data = '';
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'students.yss.su',
      port: 3306,
      user: 'iu9mobile',
      db: 'iu9mobile',
      password: 'bmstubmstu123'));
  var res = await conn.query(
      'SELECT name, email, age FROM Samokhvalova');
  for (var item in res) {
    data = '${data}\nName: ${item[0]}, Email: ${item[1]}, Age: ${item[2]} ' ;
  }
  await conn.close();
  return data;
}

void main() {
  createTable();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController outputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form for input data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Form for input data'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;
                  String email = emailController.text;
                  int age = int.tryParse(ageController.text) ?? 0;

                  await insertToDB(name, email, age);
                  outputController.text = '';
                },
                child: Text('Send'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var data = await selectFromDB();
                  outputController.text = data;
                },
                child: Text('Output information'),
              ),
              TextField(
                controller: outputController,

              ),
            ],
          ),
        ),
      ),
    );
  }
}