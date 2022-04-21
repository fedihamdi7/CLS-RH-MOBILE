// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:newapp/theme.dart';
import 'package:newapp/widgets/document_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Documents extends StatefulWidget {
  Documents({Key? key}) : super(key: key);

  @override
  State<Documents> createState() => _DocumentsState();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _DocumentsState extends State<Documents> {
  dynamic documents;
  @override
  void initState() {
    super.initState();
    getDocumentsRequests();
  }

  getDocumentsRequests() async {
    context.loaderOverlay.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    //convert user to json
    var userJson = json.decode(user!);
    var userId = userJson['_id'];
    Uri url = Uri.parse(
        "http://192.168.159.123:3000/api/employee/getMyRequests/$userId");
    var res = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'jwt $token',
    });
    var jsonResponse = json.decode(res.body);
    setState(() {
      documents = jsonResponse;
    });
    context.loaderOverlay.hide();
  }

  Future<void> _refresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getDocumentsRequests();
    });
  }

  sendRequest(String type) async {
    SmartDialog.showLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    var userJson = json.decode(user!);
    //add type to user
    userJson['type'] = type;
    // convert userJson to string
    var userString = json.encode(userJson);
    Uri url = Uri.parse("http://192.168.159.123:3000/api/employee/addRequest/");
    var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'jwt $token',
        },
        body: userString);
    var jsonResponse = json.decode(res.body);
    if (jsonResponse['success'] == true) {
      SmartDialog.showToast("Request Sent Successfully");
      getDocumentsRequests();
    } else {
      SmartDialog.showToast("An error occured");
    }
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        icon: Icons.add,
        backgroundColor: navBarColor,
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        spacing: 10,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.document_scanner,
              color: Color.fromARGB(255, 22, 118, 182),
            ),
            label: 'Work Certification',
            onTap: () {
              sendRequest("work");
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.document_scanner,
              color: Color.fromARGB(255, 126, 128, 13),
            ),
            label: 'Internship Certification',
            onTap: () {
              sendRequest("internship");
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        displacement: 20,
        onRefresh: _refresh,
        //key: refreshKeyy,
        color: navBarColor,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return DocumentCard(
              document: documents[index],
            );
          },
          itemCount: documents?.length ?? 0,
        ),
      ),
    );
  }
}
