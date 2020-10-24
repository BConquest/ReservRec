import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String filename) async {
  final path = await _localPath;
  String filePath = "$path/" + filename;
  return File(filePath);
}

Future<String> loadAsset(String filename) async {
  String filePath = "assets/" + filename;
  return await rootBundle.loadString(filePath);
}

Future<bool> isInitialRead(String filename) async {
  final file = await localFile(filename);
  if(await file.exists()) {
    return true;
  } else {
    return false;
  }
}

Future<List> loadInitialCSV(String filename) async {
  String fileContents = await loadAsset(filename);
  const conv = const CsvToListConverter(eol: ';');
  final res = conv.convert(fileContents);
  return res;
}

Future<List> loadLocalCSV(String filename) async {
  final file = await localFile(filename);
  String contents = await file.readAsString();

  const conv = const CsvToListConverter(eol: ';');
  final res = conv.convert(contents);
  return res;
}

Future<void> writeInitialCSV(String filename) async {
  List users = await loadInitialCSV(filename);
  String csv = const ListToCsvConverter(eol: ';').convert(users);
  final file = await localFile(filename);
  file.writeAsString(csv);
}

Future<void> writeNewLine(String filename, String append) async {
  List content = await loadLocalCSV(filename);
  String csv = const ListToCsvConverter(eol: ';').convert(content);
  final file = await localFile(filename);
  final String c = csv + ';\n' +append;
  file.writeAsString(c);
}