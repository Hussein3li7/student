import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/studentDetails/studentDetails.dart';

// ignore: must_be_immutable
class StudentStreamWidget extends StatelessWidget {
  Stream<QuerySnapshot> stream;
  StudentStreamWidget({this.stream});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: stream,
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
                      trailing:
                          e['mark'] == 0 ? Offstage() : Text("${e['mark']}+"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade500,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
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
