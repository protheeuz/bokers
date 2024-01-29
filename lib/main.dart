import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'onboard/onboard.dart';

// int isviewed;
Future<void> main() async {
  await initializeDateFormatting('id_ID', null);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  // isviewed = prefs.getInt('onBoard');
  runApp(MyApp());

  final cameras = await availableCameras();

  final firstCamera = cameras.first;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riska Florist Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoard(),
      // home: isviewed != 0 ? OnBoard() : Home(),
    );
  }
}
