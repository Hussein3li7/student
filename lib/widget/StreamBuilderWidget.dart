import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/studentDetails/studentDetails.dart';

// ignore: must_be_immutable
class StreamBuilderWidget extends StatefulWidget {
  Stream<QuerySnapshot> stream;
  String stage, date, qrCode;
  StreamBuilderWidget({this.stream, this.stage, this.date, this.qrCode});

  @override
  _StreamBuilderWidgetState createState() => _StreamBuilderWidgetState();
}

class _StreamBuilderWidgetState extends State<StreamBuilderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Directionality(
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
                    onTap: () async {
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (c) => StudentDetails(
                            teacherName: e["teacherName"],
                            date: e["date"],
                            qrNumber: e["qrNumber"],
                            subName: e["SubName"],
                            time: e["time"],
                            stage: widget.stage,
                            type: e["type"],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Theme.of(context).cardColor,
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right),
                        title: Text(
                          e["SubName"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Icon(Icons.menu_book),
                        //     leading: Text(e["qrNumber"].toString()),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e["teacherName"]),
                            Text(e["date"]),
                            Text(e["type"]),
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
      ),
    );
  }
}
