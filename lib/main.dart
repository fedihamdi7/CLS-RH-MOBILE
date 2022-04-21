// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:newapp/screens/add_leave.dart';
import 'package:newapp/screens/login.dart';
import 'package:newapp/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  late bool? _isConnected;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('token') != null) {
        setState(() {
          _isConnected = true;
        });
      }else{
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      initialRoute: _isConnected! ? '/navigation' : '/',
      routes: {
        '/': (context) => Login(), 
        '/navigation': (context) => CustomNavigationBar(),
        '/addLeave': (context) => AddLeaveWidget(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
