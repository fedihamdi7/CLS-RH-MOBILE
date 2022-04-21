// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:newapp/screens/documents.dart';
import 'package:newapp/screens/leaves.dart';
import 'package:newapp/screens/profile.dart';
import 'package:newapp/theme.dart';
import 'package:newapp/widgets/app_bar.dart';

class CustomNavigationBar extends StatefulWidget {
  CustomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _HomeState();
}

class _HomeState extends State<CustomNavigationBar> {
  int _currentIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Documents(),
    Leaves(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      disableBackButton: false,
      overlayColor: Colors.black.withOpacity(0.5),
      overlayWidget: Center(
        child: CircularProgressIndicator(
          color: navBarColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(
          title: "CLS - RH",
        ),
        body: _widgetOptions.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: navBarColor,
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: Color.fromARGB(255, 122, 166, 233),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_sharp),
              label: "Documents",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_off_rounded),
              label: "Leave",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
