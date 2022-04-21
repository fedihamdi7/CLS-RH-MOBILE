// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:newapp/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  var back;

  CustomAppBar({Key? key, required this.title, this.back = false})
      : super(key: key);
  logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
