import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List stdEmail = [], markes = [];
  bool loading = true;
  Map<String, Map> std = {};
  Future getStoredStd() async {
    FirebaseFirestore.instance
        .collection("storedStudents")
        .doc(widget.date)
        .collection(widget.qrNumber.toString())
        .snapshots()
        .listen((s) {
      s.docs.forEach((x) {
        setState(() {
          stdEmail.add(x['stdEmail']);
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
        onPressed: () async {
          // await OpenFile.open(excelfilePath);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Excel excel = Excel.createExcel();
  setSheetStyle() {
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("A1"),
      "Student Name",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("B1"),
      "Student Email",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );

    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("C1"),
      "Stady Type",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("D1"),
      "Stage",
      cellStyle: CellStyle(
          backgroundColorHex: "#1AFF1A",
          bold: true,
          horizontalAlign: HorizontalAlign.Center),
    );
    excel.updateCell(
      '$sheetName',
      CellIndex.indexByString("E1"),
      "Student State",
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
        horizontalAlign: HorizontalAlign.Center,
      ),
    );
  }

  Future permitionStatus() async {
    var state = Permission.storage.status;
    state.then((perState) async {
      if (perState.isGranted) {
        return saveExcelFile();
      } else if (perState.isUndetermined) {
        await Permission.storage.request().then((perState) {
          if (perState.isGranted) {
            return saveExcelFile();
          } else {
            return perState;
          }
        });
        return perState;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم رفض اذن الوصول الى الملفات ",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  saveExcelFile() async {
    setSheetStyle();
    this.std.clear();
    this.excel.delete(sheetName);
    var dir = await getApplicationDocumentsDirectory();
    await FirebaseFirestore.instance
        .collection("allStudents")
        .doc(widget.stage)
        .collection("${widget.type}")
        .snapshots()
        .listen((e) async {
      for (var i in e.docs) {
        print(i.data());
        if (stdEmail.contains(i["stdEmail"])) {
          print(
              "${stdEmail.indexOf(i['stdEmail'])}=>${i['stdEmail']}=> ${markes[stdEmail.indexOf(i['stdEmail'])]} ");
          i.data()..remove("pass")..remove("admin");
          std.addAll({
            //state =1 is mean student is present in class , state =0 mean student is absent
            i.id: {
              'stdName': i.data()['stdName'],
              'stdEmail': i.data()['stdEmail'],
              'stdtype': i.data()['stdtype'],
              'stage': i.data()['stage'],
              'state': 'حاضر',
              'mark': markes[stdEmail.indexOf(i['stdEmail'])]
            },
            // i.id: i.data()
            //   ..addAll({"state": 'حاضر'})
            //   ..addAll({'mark': markes[stdEmail.indexOf(i['stdEmail'])]}),
          });
        } else {
          std.addAll({
            i.id: {
              'stdName': i.data()['stdName'],
              'stdEmail': i.data()['stdEmail'],
              'stdtype': i.data()['stdtype'],
              'stage': i.data()['stage'],
              'state': 'غائب',
              'mark': "0"
            },

            // i.id: i.data()..addAll({"state": 'غائب'})..addAll({'mark': '0'}),
          });
        }
      }
      for (var i = 0; i < std.values.length; i++) {
        //  print(std.values.toList()[i].values.toList());
        excel.appendRow("$sheetName", std.values.toList()[i].values.toList());
      }

      // create title of data for excel file List Std name and Email and State

      ////////////////
      File excelFile;
      excel.encode().then((onValue) async {
        excelFile = await File("${dir.path}/excel.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      }).then((value) {
        print(excelFile);
        ImageGallerySaver.saveFile(excelFile.path).then((xx) async {
          print(xx);
          if (xx['isSuccess'] == true) {
            setSnakbar(xx["filePath"]);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "حدث خطأ اثناء حفظ الملف يرجى منح صلاحية الوصول للملفات قبل الحفظ"),
              ),
            );
          }
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
                      stage: int.parse(widget.stage),
                      stageType: widget.type,
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
                  emails: stdEmail,
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
        onPressed: permitionStatus,
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
      //           if (stdEmail.contains(i["stdEmail"])) {
      //             print(
      //                 "${stdEmail.indexOf(i['stdEmail'])}=>${i['stdEmail']}=> ${markes[stdEmail.indexOf(i['stdEmail'])]} ");
      //             std.addAll({
      //               i.id: i.data()
      //                 ..addAll({"state": '1'})
      //                 ..addAll({'mark': markes[stdEmail.indexOf(i['stdEmail'])]}),
      //             });
      //           } else {
      //             std.addAll({
      //               i.id: i.data()
      //                 ..addAll({"state": '0'})
      //                 ..addAll({'mark': '0'}),
      //             });
      //           }
      //         }
      //         // print(stdEmail);
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
