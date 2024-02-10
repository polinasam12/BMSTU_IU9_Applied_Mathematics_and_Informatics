import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'smtp_commands_screen.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SMTPScreen(),
    );
  }
}

class SMTPScreen extends StatefulWidget {
  @override
  _SMTPScreenState createState() => _SMTPScreenState();
}

class _SMTPScreenState extends State<SMTPScreen> {
  late TextEditingController _smtpHostController = TextEditingController();
  late TextEditingController _smtpUsernameController = TextEditingController();
  late TextEditingController _smtpKeyController = TextEditingController();
  late TextEditingController _smtpPortController = TextEditingController();

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
    _smtpHostController.text = _prefs.getString('smtpHost') ?? '';
    _smtpUsernameController.text = _prefs.getString('smtpUsername') ?? '';
    _smtpKeyController.text = _prefs.getString('smtpKey') ?? '';
    _smtpPortController.text = _prefs.getString('smtpPort') ?? '';
  }

  void _saveSmtpSettings() {
    _prefs.setString('smtpHost', _smtpHostController.text);
    _prefs.setString('smtpUsername', _smtpUsernameController.text);
    _prefs.setString('smtpKey', _smtpKeyController.text);
    _prefs.setString('smtpPort', _smtpPortController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SMTP settings saved')),
    );
  }

  void _navigateToEmailComposeScreen() {
    SmtpParams params = SmtpParams(
      host: _smtpHostController.text,
      username: _smtpUsernameController.text,
      key: _smtpKeyController.text,
      port: _smtpPortController.text,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailComposeScreen(params: params),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMTP Data Entry Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _smtpHostController,
              decoration: InputDecoration(labelText: 'SMTP Server'),
            ),
            TextField(
              controller: _smtpUsernameController,
              decoration: InputDecoration(labelText: 'SMTP Login'),
            ),
            TextField(
              controller: _smtpKeyController,
              decoration: InputDecoration(labelText: 'SMTP Password'),
            ),
            TextField(
              controller: _smtpPortController,
              decoration: InputDecoration(labelText: 'SMTP Port'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveSmtpSettings,
              child: Text('Save'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _navigateToEmailComposeScreen,
              child: Text('Create an email'),
            ),
          ],
        ),
      ),
    );
  }
}

