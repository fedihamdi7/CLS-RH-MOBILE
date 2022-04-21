// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:newapp/theme.dart';
import 'package:newapp/widgets/app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  String? file;
  String? type;
  PDFViewer({Key? key, this.file, this.type}) : super(key: key);

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  Dio dio = Dio();
  var url;
  @override
  void initState() {
    super.initState();
    setState(() {
      url = widget.type! == "document"
          ? "http://192.168.159.123:3000/assets/certifications/"
          : "http://192.168.159.123:3000/assets/leaves/accepted/";
    });
  }

  void downloadFile() async {
    // String url = "http://192.168.159.123:3000/assets/leaves/accepted/";
    String fileName = widget.file!;

    String path = await _getFilePath(fileName);
    SmartDialog.showLoading();
    await dio
        .download(
      url + fileName,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {},
      deleteOnError: true,
    )
        .then((_) {
      SmartDialog.showToast("File Saved Successfully");
      SmartDialog.dismiss();
    });
  }

  Future<String> _getFilePath(String filename) async {
    final Directory? extDir = await getExternalStorageDirectory();
    final String dirPath = extDir!.path.toString();
    await Directory(dirPath).create(recursive: true);
    final output = await getExternalStorageDirectory();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    RegExp pathToDownloads = RegExp(r'.+0\/');

    final downloadPath =
        '${pathToDownloads.stringMatch(output!.path).toString()}Download';
    return "$downloadPath/$filename";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "PDF Viewer",
        back: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navBarColor,
        onPressed: () {
          downloadFile();
        },
        child: const Icon(Icons.download),
      ),
      body: SfPdfViewer.network(
        '$url${widget.file}',
      ),
    );
  }
}
