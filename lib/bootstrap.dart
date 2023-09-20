import 'package:delivery_app/app.dart';
import 'package:delivery_app/environment.dart';
import 'package:delivery_app/src/helpers/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterLogs.initLogs(
    logLevelsEnabled: [LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR, LogLevel.SEVERE],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    directoryStructure: DirectoryStructure.FOR_DATE,
    logTypesEnabled: ["device", "network", "errors"],
    logFileExtension: LogFileExtension.CSV,
    logsWriteDirectoryName: "MyLogs",
    logsExportDirectoryName: "MyLogs/Exported",
    debugFileOperations: !isProd(),
    isDebuggable: !isProd(),
    encryptionEnabled: Environment.logsEncryptionKey != null,
    encryptionKey: Environment.logsEncryptionKey ?? "",
  );

  await Firebase.initializeApp();

  FirebaseApp appy = Firebase.app();
  FlutterLogs.logInfo(
    "bootstrap",
    "firebase",
    {"projectId": appy.options.projectId}.toString(),
  );

  var uuid = Uuid();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String newId = uuid.v4();
  prefs.setString("session_id", newId);

  FlutterLogs.logInfo(
    "bootstrap",
    "session",
    {
      "state": "started",
      "id": newId,
    }.toString(),
  );

  runApp(MyApp());
}
