import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentStreamWidget extends StatefulWidget {
  Stream<QuerySnapshot> stream;
  List emails;
  StudentStreamWidget({this.stream, this.emails});

  @override
  _StudentStreamWidgetState createState() => _StudentStreamWidgetState();
}

class _StudentStreamWidgetState extends State<StudentStreamWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future getData() async {}

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
                return Card(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    // trailing:
                    //     e['mark'] == 0 ? Offstage() : Text("${e['mark']}+"),
                    leading: widget.emails.contains(e['stdEmail'])
                        ? CircleAvatar(
                            backgroundColor: Colors.green.shade500,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.red.shade500,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                    title: Text(e["stdName"]),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text(e["date"]),
                        // Text(e["time"]),
                      ],
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
