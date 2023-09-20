import 'dart:io';
import 'dart:typed_data';

import 'package:delivery_app/environment.dart';
import 'package:path_provider/path_provider.dart';

bool isProd() {
  return Environment.envName == "production";
}

Future<String> createFileFromByteData(Uint8List data) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  String fullPath = '$dir/test.png';
  File file = File(fullPath);
  await file.writeAsBytes(data);
  return file.path;
}

bool passwordValidation(String str) {
  return RegExp(r'([a-zA-Z]+)').hasMatch(str) && RegExp(r'([0-9]+)').hasMatch(str);
}
