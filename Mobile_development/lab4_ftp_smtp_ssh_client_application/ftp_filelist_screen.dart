import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:file_picker/file_picker.dart';

class FileListScreen extends StatefulWidget {
  final String server;
  final String login;
  final String password;

  FileListScreen(
      {required this.server, required this.login, required this.password});

  @override
  _FileListScreenState createState() =>
      _FileListScreenState(server, login, password);
}

class FTPManager {
  late String _server;
  late String _login;
  late String _password;
  late FTPConnect _ftpConnect;

  List _fileList = [];
  String _currentDir = "";
  // List<String> _currentPath = [];

  List get fileList => _fileList;
  // late List<String> consoleLogs = [];

  int maxLogCount = 4;
  late List<String> consoleLogs = List<String>.generate(
      maxLogCount, (index) => "");

  FTPManager(String server, String login, String password) {
    _server = server;
    _login = login;
    _password = password;
    _ftpConnect =
        FTPConnect(_server, user: _login, pass: _password, showLog: true);
  }

  Function()? _onUpdate;

  void _log(String message) {
    final DateTime now = DateTime.now();
    final String formattedTime = "[${now}] ";
    final formattedMessage = formattedTime + "> " + message;
    consoleLogs.insert(0, formattedMessage);
    if (consoleLogs.length > maxLogCount) {
      consoleLogs.removeLast();
    }
    _onUpdate!();
  }

  void setOnUpdateCallback(Function() onUpdate) {
    _onUpdate = onUpdate;
  }

  Future<void> connect() async {
    try {
      await _ftpConnect.connect();
      _log("Connected to " + _server);
    } catch (error) {
      _log("FTP connection error: " + error.toString());
    }
  }

  Future<void> disconnect() async {
    await _ftpConnect.disconnect();
    _fileList.clear();
    _currentDir = '';
    _log("Disconnected from " + _server);
  }

  Future<void> refreshFTPData(String currentDir) async {
    // _currentPath.add(currentDir);
    print("Refreshing");
    // print(_currentPath.join("/"));
    await _ftpConnect.changeDirectory(currentDir);
    List dirList = await _ftpConnect.listDirectoryContent();
    _fileList = dirList;
    _currentDir = currentDir;
    // for (var file in dirList) {
    //   print('File name: ${file.name}' + 'File type ${file.type}');
    // }
    if (currentDir == "") {
      _log("Refreshing in current directory");
    } else {
      _log("Refreshing in directory: " + currentDir);

    }
  }

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      await uploadFileToFTP(file);
    } else {

    }
  }

  Future<void> uploadFileToFTP(File fileName) async {
    try {
      await _ftpConnect.uploadFile(fileName);
      _log("File ${fileName} has been successfully uploaded to FTP");
      refreshFTPData('');
    } catch (error) {
      _log("FTP upload error: ${error.toString()}");
    }
  }

  Future<void> deleteFileFromFTP(String fileName) async {
    // implementation for deleting file from FTP
    try {
      await _ftpConnect.deleteFile(fileName);
      _log("File: " + fileName + "deleted successfully");
      refreshFTPData('');
    } catch (error) {
      _log("FTP deleting error: " + error.toString());
    }
  }

  Future<void> downloadFileFromFTP(String fileName) async {

    try {
      File localFilePath = File("/home/user1/" + fileName);
      _log("Local path: " + localFilePath.toString());
      await _ftpConnect.downloadFile(fileName, localFilePath);
      _log("File: " + fileName + " downloaded successfully");
    } catch (error) {
      _log("FTP download error: " + error.toString());
    }
  }

  Future<void> createFTPDirectory(String currentDir) async {
    // implementation for creating directory on FTP

    try {
      await _ftpConnect.makeDirectory(currentDir);
      _log("New directory created successfully: " + currentDir);
      refreshFTPData('');
    } catch (error) {
      _log("FTP creating directory error: " + error.toString());
    }
  }
}

class _FileListScreenState extends State<FileListScreen> {
  late String _server;
  late String _login;
  late String _password;
  late FTPManager _ftpManager;

  _FileListScreenState(String server, String login, String password) {
    _server = server;
    _login = login;
    _password = password;
    _ftpManager = FTPManager(_server, _login, _password);
    _ftpManager.setOnUpdateCallback(_onUpdate);
  }

  _onUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ftpManager.connect().then((_) {
      _ftpManager.refreshFTPData('').then((_) {
        _onUpdate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File List Screen'),
      ),
      body: Column(
        children: [
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text('Current Path: ' + _ftpManager._currentDir),
          // ),

          Expanded(
            child: ListView.builder(
              itemCount: _ftpManager.fileList.length,

              itemBuilder: (context, index) {
                final file = _ftpManager.fileList[index];
                final isDirectory = file.type.toString() == "FTPEntryType.DIR";
                final icon =
                    isDirectory ? Icons.folder : Icons.insert_drive_file;
                final color = isDirectory ? Colors.orange : Colors.grey;

                return ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(file.name),
                  onTap: () async {
                    final currentFile = _ftpManager.fileList[index].name;
                    // final currentPath = _ftpManager._currentPath.join("/");
                    // final path = currentPath.isNotEmpty ? "$currentPath/$currentFile" : currentFile;
                    await _ftpManager.refreshFTPData(currentFile);
                    setState(
                        () {});
                  },
                  onLongPress: () {

                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(0, 0, 0, 0),
                      items: [
                        const PopupMenuItem(
                          value: "download",
                          child: Text("Download file"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete file"),
                        ),
                      ],
                    ).then((value) {
                      if (value == "download") {
                        // if (_ftpManager.fileList[index].type == "FTPEntryType.FILE") {
                        final currentFile = _ftpManager.fileList[index].name;
                        _ftpManager.downloadFileFromFTP(currentFile);
                        // }
                      } else if (value == "delete") {

                        _ftpManager.deleteFileFromFTP(_ftpManager.fileList[index].name);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height /
                6,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ListView.builder(
              itemCount: _ftpManager.consoleLogs.length,
              itemBuilder: (context, index) {
                return Text(_ftpManager.consoleLogs[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _ftpManager.disconnect();
                  setState(() {});
                },
                child: Text('Disconnect'),
              ),
              SizedBox(width: 10),


              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String newDir = "";
                      return AlertDialog(
                        title: Text('Create a new folder'),
                        content: TextField(
                          onChanged: (value) {
                            newDir = value;
                          },
                          decoration: InputDecoration(hintText: "Enter the folder name"),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _ftpManager.createFTPDirectory(newDir);
                              Navigator.of(context).pop();
                            },
                            child: Text('Create'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Create directory'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _ftpManager._openFileExplorer();
                },
                child: Text('Upload to FTP'),
              ),
              SizedBox(width: 10),

            ],
          ),
        ],
      ),
    );
  }
}
