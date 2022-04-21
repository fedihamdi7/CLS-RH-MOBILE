// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, must_be_immutable


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newapp/screens/pdf_viewer.dart';


class DocumentCard extends StatefulWidget {
  Map<String, dynamic>? document;

  DocumentCard({Key? key, this.document}) : super(key: key);

  @override
  State<DocumentCard> createState() => DocumentCardState();
}

class DocumentCardState extends State<DocumentCard> {
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(
              Icons.document_scanner,
              color: widget.document!["type"] == "work"
                  ? Color.fromARGB(255, 22, 118, 182)
                  : Color.fromARGB(255, 126, 128, 13),
            ),
          ),
          title: Text(widget.document!["type"] + " " + "certificate"),
          subtitle: Text(
            widget.document!["status"] +
                " • " +
                DateFormat.yMMMMd()
                    .format(
                      DateTime.parse(widget.document!["sent_date"]),
                    )
                    .toString(),
          ),
          trailing: IconButton(
            onPressed: widget.document!["status"] == "in progress"
                ? null
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PDFViewer(file: widget.document!["file"], type : "document")));
                  },
            icon: widget.document!["status"] == "in progress"
                ? Icon(Icons.download_rounded)
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
