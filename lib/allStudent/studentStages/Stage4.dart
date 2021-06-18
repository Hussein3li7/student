import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stage4 extends StatefulWidget {
  String stage, type;
  Stage4({Key key, @required this.stage, @required this.type}) : super(key: key);

  @override
  _Stage4State createState() => _Stage4State();
}

class _Stage4State extends State<Stage4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("allStudents")
              .doc(widget.stage)
              .collection(widget.type)
              .snapshots(),
          builder: (BuildContext c, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              default:
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return Column(
                children: snapshot.data.docs.map((e) {
                  return Card(
                      child: ListTile(
                    title: Text(e['stdName']),
                    subtitle: Text(e['stdEmail']),
                  ));
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
