import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test1/pages/tags_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || Platform.isAndroid) {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyWidget(),);
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TagsPage();
  }
}
