// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, must_be_immutable, non_constant_identifier_names, empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newapp/config/config.dart';
import 'package:newapp/theme.dart';
import 'package:newapp/widgets/app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AddLeaveWidget extends StatefulWidget {
  AddLeaveWidget({Key? key}) : super(key: key);

  @override
  State<AddLeaveWidget> createState() => _AddLeaveWidgetState();
}

class _AddLeaveWidgetState extends State<AddLeaveWidget> {
  void pickFile() async {
    try {
      result = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: false);
      if (result != null) {
        fileName = result!.files.first.name;
        file = result!.files.first;
        fileToUpload = (File(file!.path.toString()));
      }
      // print("file is : ${fileToUpload}");
    } catch (e) {}
  }

  String _salutation = "Casual";
  final _salutations = [
    "Casual",
    "Sick",
    "Maternity",
    "Paternity",
    "Bereavement",
    "Compensatory"
  ];
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  FilePickerResult? result;
  String? fileName;
  PlatformFile? file;
  File? fileToUpload;
  DateTime? leave_start_date;
  DateTime? leave_end_date;
  String? type = "casual";

  void onAddLeave() async {
    SmartDialog.showLoading();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user = sharedPreferences.getString('user');
    var userJson = json.decode(user!);
    var token = sharedPreferences.getString('token');
    var from = userJson['_id'];
    Uri url = Uri.parse("$apiUrl/api/leave/addLeave");
    var body = <String, String>{};
    body['from'] = from;
    body['type'] = _salutation;
    body['leave_start_date'] = leave_start_date.toString();
    body['leave_end_date'] = leave_end_date.toString();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'jwt $token'
    };
    http.MultipartRequest request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    if (fileToUpload != null) {
      http.MultipartFile? multipartFile =
          await http.MultipartFile.fromPath('file', fileToUpload!.path);
      request.files.add(multipartFile);
    }

    request.fields.addAll(body);
    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      SmartDialog.showToast("Leave Request Sent Successfully");
      Navigator.pop(context);
    } else {
      SmartDialog.showToast("An Error Occured");
    }
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: "Add Leave",
        back: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              controller: _startDateController,
              decoration: const InputDecoration(
                hintText: 'Leave Start date',
                icon: Icon(Icons.date_range),
              ),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: leave_start_date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((date) {
                  setState(() {
                    leave_start_date = date;
                    _startDateController.text =
                        DateFormat.yMMMEd().format(date!);
                  });
                });
              },
            ),
            TextField(
              readOnly: true,
              controller: _endDateController,
              decoration: const InputDecoration(
                hintText: 'Leave end date',
                icon: Icon(Icons.date_range),
              ),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: leave_start_date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((date) {
                  setState(() {
                    leave_end_date = date;
                    _endDateController.text = DateFormat.yMMMEd().format(date!);
                  });
                });
              },
            ),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: fileName),
              decoration: const InputDecoration(
                icon: Icon(Icons.attach_file),
              ),
              onTap: () {
                pickFile();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2, right: 10),
                  child: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Color.fromARGB(255, 134, 134, 134),
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: DropdownButton(
                    items: _salutations
                        .map((String item) => DropdownMenuItem<String>(
                            child: Text(item), value: item))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _salutation = value!;
                      });
                    },
                    value: _salutation,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: navBarColor),
              onPressed: () {
                onAddLeave();
              },
              child: Text("Add Leave"),
            ),
          ],
        ),
      ),
    );
  }
}
