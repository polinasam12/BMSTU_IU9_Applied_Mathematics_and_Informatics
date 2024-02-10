import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';

class SSHCommandsScreen extends StatefulWidget {
  final String host;
  final String username;
  final String password;
  final String port;

  SSHCommandsScreen({
    required this.host,
    required this.username,
    required this.password,
    required this.port,
  });

  @override
  _SSHCommandsScreenState createState() => _SSHCommandsScreenState(host, username, password, port);
}




class SSHManager {
  late String _server;
  late String _login;
  late String _password;
  late String _port;
  late SSHClient client;

  List _fileList = [];
  late List<String> consoleLogs = [];
  int maxLogCount = 100;

  SSHManager(String server, String login, String password, String port) {
    _server = server;
    _login = login;
    _password = password;
    _port = port;
  }

  void _log(String message) {
    final DateTime now = DateTime.now();
    final String formattedTime = "[${now}] ";
    final formattedMessage = formattedTime + "> " + message;
    consoleLogs.insert(0, formattedMessage);
    if (consoleLogs.length > maxLogCount) {
      consoleLogs.removeLast();
    }
  }

  Future<void> connect() async {
    try {
      final socket = await SSHSocket.connect(_server, int.parse(_port));
      client = SSHClient(
        socket,
        username: _login,
        onPasswordRequest: () => _password,
      );

      _log("Connected to " + _server);

      final response = await client.run('uname');
      _log(utf8.decode(response));
    } catch (error) {
      _log("SSH connection error: " + error.toString());
    }
  }


  Future<void> disconnect() async {
    try {
      client.close();
      await client.done;
      _log("Disconnected from " + _server);
    } catch (error) {
      _log("Error while disconnecting: " + error.toString());
    }
  }


  Future<void> command(String cmd) async {
    try {
      final response = await client.run(cmd);
      _log(utf8.decode(response));

      _log("Command " + cmd + " executed successfully");
    } catch (error) {
      _log("Command execution error: " + error.toString());
    }
  }

}

class _SSHCommandsScreenState extends State<SSHCommandsScreen> {
  late SSHManager _sshManager;

  _SSHCommandsScreenState(String server, String login, String password, String port) {
    _sshManager = SSHManager(server, login, password, port);
  }

  @override
  void initState() {
    super.initState();
    _sshManager.connect().then((_) {
      setState(() {});
    });
  }

  void _executeCommand(String command) {
    _sshManager.command(command).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    String cmd = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Commands Screen'),
      ),
      body: Column(
        children: [

          TextField(
            onChanged: (value) {
              cmd = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter command',
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _executeCommand(cmd);
                },
                child: Text('Execute'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _sshManager.disconnect();
                },
                child: Text('Disconnect'),
              ),
            ],
          ),


          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //   border: Border.all(),
              // ),
              child: ListView.builder(
                itemCount: _sshManager.consoleLogs.length,
                itemBuilder: (context, index) {
                  return Text(_sshManager.consoleLogs[index]);
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
