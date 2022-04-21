// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/theme.dart';
import 'package:newapp/widgets/leave_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Leaves extends StatefulWidget {
  const Leaves({Key? key}) : super(key: key);

  @override
  State<Leaves> createState() => _LeavesState();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _LeavesState extends State<Leaves> {
  dynamic leaves;
  @override
  void initState() {
    super.initState();
    getLeaves();
  }

  Future<void> _refresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getLeaves();
    });
  }

  getLeaves() async {
    context.loaderOverlay.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    //convert user to json
    var userJson = json.decode(user!);
    var userId = userJson['_id'];
    Uri url = Uri.parse(
        "http://192.168.159.123:3000/api/leave/getLeavesByUserId/$userId");
    var res = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'jwt $token',
    });
    var jsonResponse = json.decode(res.body);
    //revert the list
    List<dynamic> reversedList = [];
    for (var i = jsonResponse.length - 1; i >= 0; i--) {
      reversedList.add(jsonResponse[i]);
    }
    setState(() {
      leaves = reversedList;
    });
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addLeave');
        },
        child: Icon(Icons.add),
        backgroundColor: navBarColor,
      ),
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: leaves == null ? 0 : leaves.length,
          itemBuilder: (BuildContext context, int index) {
            return LeaveCard(
              leave: leaves[index],
            );
          },
        ),
      ),
    );
  }
}
