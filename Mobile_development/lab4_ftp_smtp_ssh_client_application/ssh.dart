import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ssh_commands_screen.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SSHScreen(),
    );
  }
}

class SSHScreen extends StatefulWidget {
  @override
  _SSHScreenState createState() => _SSHScreenState();
}

class _SSHScreenState extends State<SSHScreen> {
  late TextEditingController _sshHostController = TextEditingController();
  late TextEditingController _sshUsernameController = TextEditingController();
  late TextEditingController _sshKeyController = TextEditingController();
  late TextEditingController _sshPortController = TextEditingController();

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
    _sshHostController.text = _prefs.getString('sshHost') ?? '';
    _sshUsernameController.text = _prefs.getString('sshUsername') ?? '';
    _sshKeyController.text = _prefs.getString('sshPassword') ?? '';
    _sshPortController.text = _prefs.getString('sshPort') ?? '';
  }

  void _saveSshSettings() {
    _prefs.setString('sshHost', _sshHostController.text);
    _prefs.setString('sshUsername', _sshUsernameController.text);
    _prefs.setString('sshPassword', _sshKeyController.text);
    _prefs.setString('sshPort', _sshPortController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SSH settings saved')),
    );
  }

  void _navigateToSSHCommandsScreen() {
    String host = _sshHostController.text;
    String username = _sshUsernameController.text;
    String password = _sshKeyController.text;
    String port = _sshPortController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SSHCommandsScreen(
          host: host,
          username: username,
          password: password,
          port: port,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Data Entry Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _sshHostController,
              decoration: InputDecoration(labelText: 'SSH Server'),
            ),
            TextField(
              controller: _sshUsernameController,
              decoration: InputDecoration(labelText: 'SSH Login'),
            ),
            TextField(
              controller: _sshKeyController,
              decoration: InputDecoration(labelText: 'SSH Password'),
            ),
            TextField(
              controller: _sshPortController,
              decoration: InputDecoration(labelText: 'SSH Port'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveSshSettings,
              child: Text('Save'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _navigateToSSHCommandsScreen,
              child: Text('Connect to SSH server'),
            ),
          ],
        ),
      ),
    );
  }
}

