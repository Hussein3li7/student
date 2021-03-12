import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:student/pdfRunder/pdfPerview.dart';
import 'package:student/widget/studentStreamWidget.dart';

// ignore: must_be_immutable
class StudentDetails extends StatefulWidget {
  String date, time, subName, teacherName, stage, type;
  int qrNumber;
  StudentDetails(
      {this.teacherName,
      this.subName,
      this.date,
      this.time,
      this.qrNumber,
      this.stage,
      this.type});

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  void initState() {
    super.initState();
    getStoredStd();
  }

  List uid = [], markes = [];
  bool loading = true;

  Future getStoredStd() async {
    print("okokok");
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

  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التفاصيل"),
        centerTitle: true,
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
        onPressed: () async {
          Map<String, Map> std = {};
          FirebaseFirestore.instance
              .collection("allStudents")
              .doc(widget.stage)
              .collection("${widget.type}")
              .snapshots()
              .listen(
            (e) async {
              for (var i in e.docs) {
                if (uid.contains(i["stdEmail"])) {
                  print(
                      "${uid.indexOf(i['stdEmail'])}=>${i['stdEmail']}=> ${markes[uid.indexOf(i['stdEmail'])]} ");
                  std.addAll({
                    i.id: i.data()
                      ..addAll({"state": '1'})
                      ..addAll({'mark': markes[uid.indexOf(i['stdEmail'])]}),
                  });
                } else {
                  std.addAll({
                    i.id: i.data()
                      ..addAll({"state": '0'})
                      ..addAll({'mark': '0'}),
                  });
                }
              }
              // print(uid);
              //   print(std);

              writeOnPdf(
                  teacherName: widget.teacherName,
                  date: widget.date,
                  subName: widget.subName,
                  stream: std);
              await savePdf();
              Directory documentDirectory =
                  await getApplicationDocumentsDirectory();

              String documentPath = documentDirectory.path;

              String fullPath =
                  "$documentPath/${widget.date}+${widget.teacherName}+${widget.subName}.pdf";

              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PdfPreviewScreen(
                    path: fullPath,
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.save),
      ),
    );
  }

  writeOnPdf(
      {String teacherName,
      String date,
      String subName,
      Map<String, Map> stream}) async {
    // final font = await rootBundle.load("fonts/HacenTunisia.ttf");
    // final ttf = pw.Font.ttf(font);
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("fonts/HacenTunisia.ttf"));
    pdf.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text("$date"),
                  pw.Text(
                    "$teacherName",
                  ),
                  pw.Text("$subName"),
                ],
              ),
            ),
          ),
          pw.Directionality(
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColor.fromHex("#333"),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: <pw.Widget>[
                  pw.Container(
                    child: pw.Text(
                      'الحالة',
                    ),
                  ),
                  pw.Container(
                    child: pw.Text(
                      'الاضافة',
                    ),
                  ),
                  pw.Container(
                    child: pw.Text(
                      'اسم الطالب',
                    ),
                  ),
                  pw.Container(
                    child: pw.Text(
                      'ت',
                    ),
                  ),
                  //   "${e['mark'].toString()}",
                ],
              ),
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: stream.values.map((e) {
                return pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColor.fromHex("#333"),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: <pw.Widget>[
                      e['state'] == "1"
                          ? pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                "حاضر",
                              ),
                            )
                          : pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                "غائب",
                              ),
                            ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          "${e['mark']}+",
                        ),
                      ),
                      pw.Container(
                        child: pw.Text(
                          e["stdName"],
                          textAlign: pw.TextAlign.right,
                        ),
                      ),

                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          "${stream.values.toList().indexOf(e) + 1}",
                        ),
                      ),
                      //   "${e['mark'].toString()}",
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // pw.Directionality(
          //   textDirection: pw.TextDirection.rtl,
          //   child: pw.Table(children: <pw.TableRow>[
          //     pw.TableRow(
          //       children: <pw.Widget>[
          //         pw.Text(
          //           'اسم الطالب',
          //           textAlign: pw.TextAlign.right,
          //         ),
          //         pw.Text(
          //           'الاضافات',
          //           textAlign: pw.TextAlign.right,
          //         ),
          //       ],
          //       decoration: pw.BoxDecoration(
          //         border: pw.Border.all(
          //           color: PdfColor.fromHex("#333"),
          //         ),
          //       ),
          //     ),
          //   ]),
          // ),
          // pw.Directionality(
          //   textDirection: pw.TextDirection.rtl,
          //   child: pw.ListView(
          //     children: stream.values.map((e) {
          //       return pw.Directionality(
          //         textDirection: pw.TextDirection.rtl,
          //         child: pw.Table(
          //           children: <pw.TableRow>[
          //             pw.TableRow(
          //               verticalAlignment: pw.TableCellVerticalAlignment.middle,
          //               children: <pw.Widget>[
          //                 pw.Text(
          //                   e["studentName"],
          //                   textAlign: pw.TextAlign.right,
          //                 ),
          //                 pw.Text(
          //                   "${e['mark'].toString()}",
          //                   textAlign: pw.TextAlign.right,
          //                 ),
          //               ],
          //               decoration: pw.BoxDecoration(
          //                 border: pw.Border.all(
          //                   color: PdfColor.fromHex("#333"),
          //                 ),
          //               ),
          //             ),
          //           ],
          //           defaultVerticalAlignment:
          //               pw.TableCellVerticalAlignment.middle,
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File(
        "$documentPath/${widget.date}+${widget.teacherName}+${widget.subName}.pdf");

    file.writeAsBytesSync(await pdf.save());
  }
}
