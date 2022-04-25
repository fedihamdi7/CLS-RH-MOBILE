// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:newapp/config/config.dart';
import 'package:newapp/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  var back;

  CustomAppBar({Key? key, required this.title, this.back = false})
      : super(key: key);
  logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    var userJson = json.decode(user!);
    var token = prefs.getString('token');
    var from = userJson['_id'];
    Uri url = Uri.parse("$apiUrl/api/employee/removeDeviceId/$from");
    var res = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'jwt $token',
        });

    // clear shared preferences
    prefs.clear();
    // navigate to login screen
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: back,
      title: Text(
        title,
        style: TextStyle(letterSpacing: 2),
      ),
      backgroundColor: navBarColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            logout(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
