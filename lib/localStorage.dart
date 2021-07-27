import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import "package:flutter_secure_storage/flutter_secure_storage.dart";

final _storage = new FlutterSecureStorage();
Future<void> writeToLocalStorage(String field, dynamic value) async {
  await _storage.write(key: field, value: json.encode(value));
}

Future<dynamic> readFromLocalStorage(String field) async {
  try {
    var ret = json.decode((await _storage.read(key: field)));
    return ret;
  } catch (err) {
    print("Field not present: $field");
    return null;
  }
}

Future<void> removeFromLocalStorage(String field) async {
  try {
    await _storage.delete(key: field);
  } catch (err) {
    print("Field not present: $field");
    throw new ErrorDescription("Field $field not present in storage");
  }
}

Future<void> clearLocalStorage() async {
  await _storage.deleteAll();
}
