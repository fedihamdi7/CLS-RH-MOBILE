// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Map> data = [];

  getProfileData() async {
    context.loaderOverlay.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    //convert user to json
    var userJson = json.decode(user!);
    var userId = userJson['_id'];
    Uri url = Uri.parse(
        "http://192.168.159.123:3000/api/employee/getEmployeeById/$userId");
    var res = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'jwt $token',
    });
    var jsonResponse = json.decode(res.body);

    List<Map> result = [
      {
        "label": "Name",
        "value": jsonResponse["firstName"] + " " + jsonResponse["lastName"],
      },
      {
        "label": "Email",
        "value": jsonResponse["email"],
      },
      {
        "label": "Phone",
        "value": jsonResponse["phone"],
      },
      {
        "label": "CIN",
        "value": jsonResponse["cin"],
      },
      {
        "label": "Job Title",
        "value": jsonResponse["job_title"],
      },
      {
        "label": "Leaves Left",
        "value": jsonResponse["leaves_left"].toString(),
      },
      {
        "label": "Joining Date",
        "value":
            DateFormat.yMMMMd().format(DateTime.parse(jsonResponse["date_in"])),
      },
    ];

    setState(() {
      data = result;
    });
    context.loaderOverlay.hide();
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]["label"]),
                    subtitle: Text(data[index]["value"]),
                  );
                },
                itemCount: data.length,
                shrinkWrap: true),
          ),
        ],
      ),
    );
  }
}

class LabelData extends StatelessWidget {
  String text;
  LabelData({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 37, 25, 25),
      ),
    );
  }
}

class Label extends StatelessWidget {
  late String text;
  Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 129, 25, 133),
      ),
    );
  }
}
