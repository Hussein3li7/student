import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stage3 extends StatefulWidget {
  String stage, type;
  Stage3({Key key, @required this.stage, @required this.type}) : super(key: key);

  @override
  _Stage3State createState() => _Stage3State();
}

class _Stage3State extends State<Stage3> {
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
