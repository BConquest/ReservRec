import 'dart:convert';
import 'package:crypto/crypto.dart';

String Sha256(String password){
  var bytes_password = utf8.encode(password);
  var hexed = sha256.convert(bytes_password);
  return hexed.toString();
}