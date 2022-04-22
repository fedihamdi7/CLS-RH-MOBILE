// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:newapp/config/config.dart';
import 'package:newapp/screens/add_leave.dart';
import 'package:newapp/screens/login.dart';
import 'package:newapp/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

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

  Future<void> updateDeviceID(deviceID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    //convert user to json
    var userJson = json.decode(user!);
    var userId = userJson['_id'];
    Uri url = Uri.parse("$apiUrl/api/employee/updateDeviceId/$userId");
    var res = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'jwt $token',
        },
        body: jsonEncode({"device_id": deviceID}));
    var jsonResponse = json.decode(res.body);
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId("a7195059-2c3e-4434-8619-6a551b0bc3ae");
    await OneSignal.shared
        .getDeviceState()
        .then((value) => {updateDeviceID(value!.userId)});
  }

  @override
  void initState() {
    super.initState();
    initPlatform();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('token') != null) {
        setState(() {
          _isConnected = true;
        });
      } else {
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
