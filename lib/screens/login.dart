// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newapp/config/config.dart';
import 'package:newapp/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  onSubmit(String email, String password) async {
    email.trimLeft();
    email.trimRight();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = jsonEncode({'email': email.trim(), 'password': password.trim()});
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      SmartDialog.showToast("Please enter email and password");
    } else {
      SmartDialog.showLoading();
      Uri url = Uri.parse("$apiUrl/api/employee/login");
      var res = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      var jsonResponse = json.decode(res.body);
      SmartDialog.dismiss();
      if (jsonResponse['success']) {
        await initPlatform();
        // put token and user in shared prefs
        var user = json.encode(jsonResponse['user']);
        prefs.setString('token', jsonResponse['token']);
        prefs.setString('user', user);
        SmartDialog.showToast("Welcome Back");
        Navigator.pushReplacementNamed(context, '/navigation');
      } else {
        SmartDialog.showToast(jsonResponse["message"]);
      }
    }
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId("a7195059-2c3e-4434-8619-6a551b0bc3ae");
    await OneSignal.shared
        .getDeviceState()
        .then((value) => {updateDeviceID(value!.userId)});
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Login',
            style: TextStyle(letterSpacing: 2),
          ),
          backgroundColor: navBarColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 51,
                  backgroundColor: navBarColor,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo-icon.png'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: navBarColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    focusColor: navBarColor,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: navBarColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    onSubmit(_emailController.text.trim(),
                        _passwordController.text.trim());
                  },
                  child: Text('Login'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(navBarColor),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 50,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
