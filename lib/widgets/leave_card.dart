// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, must_be_immutable


import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:newapp/screens/pdf_viewer.dart';
import 'package:newapp/theme.dart';


class LeaveCard extends StatefulWidget {
  Map<String, dynamic>? leave;
  LeaveCard({Key? key, this.leave}) : super(key: key);

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  showNote(BuildContext context) async {
    SmartDialog.showAttach(
      targetContext: context,
      isPenetrateTemp: true,
      alignmentTemp: Alignment.center,
      clickBgDismissTemp: true,
      widget: Note(note: widget.leave!["note"]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(Icons.work_off),
          ),
          title: Text(widget.leave!["type"] + " " + "leave"),
          subtitle: Text(
            widget.leave!["status"] +
                " • " +
                widget.leave!["leave_days"].toString() +
                " days\n" +
                "From " +
                DateFormat.yMMMMd()
                    .format(DateTime.parse(widget.leave!["leave_start_date"]))
                    .toString() +
                " to " +
                DateFormat.yMMMMd()
                    .format(DateTime.parse(widget.leave!["leave_end_date"])),
            style: TextStyle(height: 1.6),
          ),
          trailing: IconButton(
            onPressed: widget.leave!["status"] == "in progress"
                ? null
                : widget.leave!["status"] == "declined"
                    ? () {
                        showNote(context);
                      }
                    : () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewer(file: widget.leave!["certificate"], type : "leave")));
                      },
            icon: widget.leave!["status"] == "in progress"
                ? Icon(Icons.download_rounded)
                : widget.leave!["status"] == "declined"
                    ? Icon(
                        Icons.info_outline,
                        color: Colors.redAccent,
                      )
                    : Icon(
                        Icons.download_rounded,
                        color: Colors.green,
                      ),
          ),
        ),
      ),
    );
  }
}

class Note extends StatefulWidget {
  String note;
  Note({Key? key, required this.note}) : super(key: key);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(left: 10),
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: navBarColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note : ",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            widget.note,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
