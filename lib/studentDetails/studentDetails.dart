import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/widget/studentStreamWidget.dart';

// ignore: must_be_immutable
class StudentDetails extends StatefulWidget {
  String date, time, subName, teacherName;
  int qrNumber;
  StudentDetails(
      {this.teacherName, this.subName, this.date, this.time, this.qrNumber});

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التفاصيل"),
        centerTitle: true,
      ),
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
          child: StudentStreamWidget(
            stream: FirebaseFirestore.instance
                .collection("storedStudents")
                .doc(widget.date)
                .collection("${widget.qrNumber}")
                .snapshots(),
          ),
        ),
      ),
    );
  }
}
