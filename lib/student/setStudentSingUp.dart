import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student/loginReg/StudentLogin.dart';
import 'package:student/service/FirebaseService.dart';

class SetStudentSingUp extends StatefulWidget {
  @override
  _SetStudentSingUpState createState() => _SetStudentSingUpState();
}

class _SetStudentSingUpState extends State<SetStudentSingUp> {
  Future permitionStatus() async {
    var state = Permission.camera.status;
    state.then((perState) async {
      if (perState.isGranted) {
        scanBarcodeNormal();
      } else {
        await Permission.camera.request().then((g) {
          if (g.isGranted) {
            scanBarcodeNormal();
          }
        });
      }
    });
  }

  String qr = "";
  Future scanBarcodeNormal() async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#1e8162", "cancel", true, ScanMode.QR);
    if (barcodeScanRes != "-1") {
      List l = barcodeScanRes.split("#");
      String subName = l[1];
      String date = l[2];
      String qrNumber = l[4];

      DateTime dateTime = DateTime.now();
      List timeDate = dateTime.toString().split(" ");
      List timeDate2 = timeDate[1].toString().split(".");
      String time = timeDate2[0];

      User user = FirebaseAuth.instance.currentUser;
      String studentName = user.displayName ?? "null";
      FirebaseService()
          .addStudents(
              studentName: studentName ?? " ",
              subName: subName ?? " ",
              date: timeDate[0] ?? date,
              time: time ?? " ",
              qrNumber: int.parse(qrNumber) ?? " ",
              email: user.email ?? "null")
          .then((e) {
        if (e.message == "Done") {
          createClassInfoDialog(
            msg: "تم تسجيل حضورك بنجاح",
            icon: Icon(
              Icons.check,
              size: 50,
              color: Colors.white,
            ),
            colors: Colors.green.shade400,
          );
        } else {
          createClassInfoDialog(
            msg: "خطا. يرجى المحاولة مرة ثانية",
            icon: Icon(
              Icons.close,
              size: 50,
              color: Colors.white,
            ),
            colors: Colors.red,
          );
        }
      });
    }
  }

  Future createClassInfoDialog({String msg, Icon icon, Color colors}) async {
    await showDialog(
      context: context,
      builder: (c) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              "$msg",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: CircleAvatar(
              backgroundColor: colors,
              radius: 50,
              child: icon,
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("الغاء"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تسجيل الحظور"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (c) {
                    return AlertDialog(
                      title: Text("تسجيل الخروج"),
                      content: Text("هل انت متاكد من تسجيل الخروج"),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("الغاء"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut().then((e) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (c) => StudentLogin(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          child: Text("خروج"),
                        )
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                "${FirebaseAuth.instance.currentUser.displayName}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 70,
              child: RaisedButton.icon(
                color: Color(0xff393776),
                onPressed: permitionStatus,
                label: Text(
                  "Scann",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
