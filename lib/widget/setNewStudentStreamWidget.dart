import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/service/FirebaseService.dart';

// ignore: must_be_immutable
class SetNewStudentStreamWidget extends StatefulWidget {
  Stream<QuerySnapshot> stream;
  int qrNumber;
  BuildContext context2;
  SetNewStudentStreamWidget({this.stream, this.qrNumber, this.context2});

  @override
  _SetNewStudentStreamWidgetState createState() =>
      _SetNewStudentStreamWidgetState();
}

class _SetNewStudentStreamWidgetState extends State<SetNewStudentStreamWidget> {
  bool addmark = false;
  TextEditingController markCtrl = new TextEditingController();

  Future createClassInfoDialog({String date, String doc}) async {
    await showDialog(
      context: widget.context2,
      builder: (c) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              "اظافة درجة مشاركة",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: CupertinoTextField(
              controller: markCtrl,
              padding: EdgeInsets.all(16),
              placeholder: "الدرجة",
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("الغاء"),
              ),
              FlatButton(
                onPressed: () {
                  if (markCtrl != null) {
                    if (markCtrl.text.isNotEmpty) {
                      print(widget.qrNumber);
                      FirebaseService()
                          .addMarkToStudents(
                              mark: int.parse(markCtrl.text),
                              date: date,
                              doc: doc,
                              qrNumber: widget.qrNumber)
                          .then((e) {
                        if (e.message == "Done") {
                          setState(() {
                            addmark = true;
                          });
                          Navigator.of(context).pop();
                        } else {
                          print(e.message);
                        }
                      });
                    }
                  }
                },
                child: Text("اظافة"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext c, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text("No Date"),
            );
          } else {
            return Column(
              children: snapshot.data.docs.map((e) {
                return GestureDetector(
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      trailing: e["mark"] == 0
                          ? IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () async {
                                await createClassInfoDialog(
                                  doc: e.id,
                                  date: e["date"].toString(),
                                );
                              },
                            )
                          : Text("${e["mark"]}+"),
                      title: Text(e["studentName"]),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e["date"]),
                          Text(e["time"]),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
