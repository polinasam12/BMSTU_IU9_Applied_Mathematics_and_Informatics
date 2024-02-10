import 'package:flutter/material.dart';
import 'ftp_filelist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FTPScreen(),
    );
  }
}

class FTPScreen extends StatefulWidget {
  @override
  _FTPScreenState createState() => _FTPScreenState();
}

class _FTPScreenState extends State<FTPScreen> {
  late TextEditingController _ftpHostController = TextEditingController();
  late TextEditingController _ftpUsernameController = TextEditingController();
  late TextEditingController _ftpPasswordController = TextEditingController();
  // late TextEditingController _ftpPortController = TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    _initTextControllers();
  }

  void _initTextControllers() {
    _ftpHostController.text = _prefs.getString('ftpHost') ?? '';
    _ftpUsernameController.text = _prefs.getString('ftpUsername') ?? '';
    _ftpPasswordController.text = _prefs.getString('ftpPassword') ?? '';
    // _ftpPortController.text = _prefs.getString('ftpPort') ?? '';
  }

  void _saveFtpSettings() {
    _prefs.setString('ftpHost', _ftpHostController.text);
    _prefs.setString('ftpUsername', _ftpUsernameController.text);
    _prefs.setString('ftpPassword', _ftpPasswordController.text);
    // _prefs.setString('ftpPort', _ftpPortController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('FTP settings saved')),
    );
  }

  void _navigateToFTPCommandsScreen() {
    String host = _ftpHostController.text;
    String username = _ftpUsernameController.text;
    String password = _ftpPasswordController.text;
    // String port = _ftpPortController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileListScreen(
          server: host,
          login: username,
          password: password,
          // port: port,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FTP Data Entry Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _ftpHostController,
              decoration: InputDecoration(labelText: 'FTP Server'),
            ),
            TextField(
              controller: _ftpUsernameController,
              decoration: InputDecoration(labelText: 'FTP Login'),
            ),
            TextField(
              controller: _ftpPasswordController,
              decoration: InputDecoration(labelText: 'FTP Password'),
            ),
            // TextField(
            //   controller: _ftpPortController,
            //   decoration: InputDecoration(labelText: 'FTP Port'),
            // ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveFtpSettings,
              child: Text('Save'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _navigateToFTPCommandsScreen,
              child: Text('Connect to FTP server'),
            ),
          ],
        ),
      ),
    );
  }
}

