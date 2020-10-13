import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv_settings_autodetection.dart';
import 'package:reservrec/test_users.dart';
import 'package:reservrec/main.dart';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/reservrec.csv');
}

Future<List> loadCSV() async {
  String fileContents = await loadAsset();

  const conv = const CsvToListConverter(eol: ';');
  final res = conv.convert(fileContents);
  return res;
}
