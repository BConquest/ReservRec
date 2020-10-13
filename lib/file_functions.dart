import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/reservrec.csv');
}

Future<String> loadAsset(String filename) async {
  String filepath = "assets/" + filename;
  return await rootBundle.loadString(filepath);
}

Future<bool> isInitialRead(String filename) async {
  final file = await _localFile;
  return file.exists();
}

Future<List> loadInitialCSV(String filename) async {
  print("INITIAL LOAD");
  String fileContents = await loadAsset(filename);

  const conv = const CsvToListConverter(eol: ';');
  final res = conv.convert(fileContents);
  return res;
}

Future<List> loadLocalCSV(String filename) async {
  print("LOCAL LOAD");
  final file = await _localFile;
  String contents = await file.readAsString();

  const conv = const CsvToListConverter(eol: ';');
  final res = conv.convert(contents);
  return res;
}

//FIX
Future<void> writeInitialCSV(String filename) async {
  print("WRITE INITIAL");
  List users = await loadInitialCSV(filename);
  String csv = const ListToCsvConverter(eol: ';\n').convert(users);
  final file = await _localFile;
  file.writeAsString(csv);

}