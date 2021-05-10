import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student/studentDetails/showStordClassQuCode.dart';
import 'package:student/widget/studentStreamWidget.dart';

// ignore: must_be_immutable
class StudentDetailsWithExcel extends StatefulWidget {
  String date, time, subName, teacherName, stage, type;
  int qrNumber;
  StudentDetailsWithExcel(
      {this.teacherName,
      this.subName,
      this.date,
      this.time,
      this.qrNumber,
      this.stage,
      this.type});

  @override
  _StudentDetailsWithExcelState createState() =>
      _StudentDetailsWithExcelState();
}

class _StudentDetailsWithExcelState extends State<StudentDetailsWithExcel> {
  @override
  void initState() {
    super.initState();
    getStoredStd();
    //   sheetName = widget.date+widget.stage+widget.qrNumber.toString();
  }

  String sheetName = "Sheet1";
  List uid = [], markes = [];
  bool loading = true;

  Future getStoredStd() async {
    print("okokok");
    print(widget.date);
    print(widget.qrNumber);
    FirebaseFirestore.instance
        .collection("storedStudents")
        .doc(widget.date)
        .collection(widget.qrNumber.toString())
        .snapshots()
        .listen((s) {
      s.docs.forEach((x) {
        print(x['stdEmail']);
        setState(() {
          uid.add(x['stdEmail']);
          markes.add(x['mark']);
          loading = false;
        });
      });
    });
  }

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/////////////////////////////Save exeil File/////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
  ///

  setSnakbar(String excelfilePath) {
    final snackBar = SnackBar(
      content: Text("تم حفظ الملف في الملفات"),
      action: SnackBarAction(
        label: "تم",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Excel excel = Excel.createExcel();
  setSheetStyle() {
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("A1"),
      "Email",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("B1"),
      "Name",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("C1"),
      "pass",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("D1"),
      "Type",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("E1"),
      "State",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("F1"),
      "Additional Mark",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
  }

  saveExcelFile() async {
    Map<String, Map> std = {};

    setSheetStyle();

    var dir = await getApplicationDocumentsDirectory();
    await FirebaseFirestore.instance
        .collection("allStudents")
        .doc(widget.stage)
        .collection("${widget.type}")
        .snapshots()
        .listen((e) async {
      for (var i in e.docs) {
        if (uid.contains(i["stdEmail"])) {
          print(
              "${uid.indexOf(i['stdEmail'])}=>${i['stdEmail']}=> ${markes[uid.indexOf(i['stdEmail'])]} ");
          std.addAll({
            //state =1 is mean student is present in class , state =0 mean student is absent
            i.id: i.data()
              ..addAll({"state": '1'})
              ..addAll({'mark': markes[uid.indexOf(i['stdEmail'])]}),
          });
        } else {
          std.addAll({
            i.id: i.data()..addAll({"state": '0'})..addAll({'mark': '0'}),
          });
        }
      }
      print(std);
      for (var i = 0; i < std.values.length; i++) {
        print(std.values.toList()[i].values.toList());
          
        excel.appendRow("$sheetName", std.values.toList()[i].values.toList());
      }
      std.clear();
      // create title of data for excel file List Std name and Email and State

      ////////////////
      File excelFile;
      excel.encode().then((onValue) async {
        excelFile = await File("${dir.path}/excel.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      }).then((value) {
        ImageGallerySaver.saveFile(excelFile.path).then((xx) async {
          print("saved ");
          print(xx["filePath"]);
          setSnakbar(xx["filePath"]);
          //excel.delete(sheetName);

          //  await OpenFile.open(excelFile.path);
        });
      });
      //  excel.insertRow("$sheetName", c);
    });

    // excel.updateCell(
    //   '$sheetName',
    //   CellIndex.indexByString("A2"),
    //   "Here value",
    //   cellStyle: CellStyle(
    //       backgroundColorHex: "#1AFF1A",
    //       horizontalAlign: HorizontalAlign.Center),
    // );
  }
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/////////////////////////////Save exeil File/////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${widget.subName} "),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.qr_code),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (c) => ShowStoredClassQrCode(
                      tName: widget.teacherName,
                      subName: widget.subName,
                      date: widget.date,
                      time: widget.time,
                      qrNumber: widget.qrNumber,
                    ),
                  ),
                );
              }),
        ],
      ),
      // body: TableWidget(
      //   title: "Table",
      // ),
      body: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StudentStreamWidget(
                  emails: uid,
                  stream: FirebaseFirestore.instance
                      .collection("allStudents")
                      .doc(widget.stage)
                      .collection(widget.type)
                      .snapshots(),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
        onPressed: saveExcelFile,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     Map<String, Map> std = {};
      //     await FirebaseFirestore.instance
      //         .collection("allStudents")
      //         .doc(widget.stage)
      //         .collection("${widget.type}")
      //         .snapshots()
      //         .listen(
      //       (e) async {
      //         for (var i in e.docs) {
      //           if (uid.contains(i["stdEmail"])) {
      //             print(
      //                 "${uid.indexOf(i['stdEmail'])}=>${i['stdEmail']}=> ${markes[uid.indexOf(i['stdEmail'])]} ");
      //             std.addAll({
      //               i.id: i.data()
      //                 ..addAll({"state": '1'})
      //                 ..addAll({'mark': markes[uid.indexOf(i['stdEmail'])]}),
      //             });
      //           } else {
      //             std.addAll({
      //               i.id: i.data()
      //                 ..addAll({"state": '0'})
      //                 ..addAll({'mark': '0'}),
      //             });
      //           }
      //         }
      //         // print(uid);
      //         //   print(std);

      //         await writeOnPdf(
      //             teacherName: widget.teacherName,
      //             date: widget.date,
      //             subName: widget.subName,
      //             stream: std);
      //         await savePdf();
      //         Directory documentDirectory =
      //             await getApplicationDocumentsDirectory();

      //         String documentPath = documentDirectory.path;

      //         String fullPath =
      //             "$documentPath/${widget.date}+${widget.teacherName}+${widget.subName}.pdf";

      //         await Navigator.push(
      //           context,
      //           CupertinoPageRoute(
      //             builder: (context) => PdfPreviewScreen(
      //               path: fullPath,
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      //   child: Icon(Icons.save),
      // ),
    );
  }
}
