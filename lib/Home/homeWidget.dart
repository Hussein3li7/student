import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/widget/StreamBuilderWidget.dart'; 

// ignore: must_be_immutable
class HomeWidget extends StatefulWidget {
  String uid;
  HomeWidget({Key key, this.uid}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "محاظرات المرحلة 1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilderWidget(
              stage: "1",
              stream: FirebaseFirestore.instance
                  .collection("class")
                  .doc("1")
                  .collection("${widget.uid}")
                  .snapshots(),
            ),
            Divider(
              thickness: 5,
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "محاظرات المرحلة 2",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilderWidget(
              stage: "2",
              stream: FirebaseFirestore.instance
                  .collection("class")
                  .doc("2")
                  .collection("${widget.uid}")
                  .snapshots(),
            ),
            Divider(
              thickness: 5,
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "محاظرات المرحلة 3",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilderWidget(
              stage: "3",
              stream: FirebaseFirestore.instance
                  .collection("class")
                  .doc("3")
                  .collection("${widget.uid}")
                  .snapshots(),
            ),
            Divider(
              thickness: 5,
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "محاظرات المرحلة 4",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilderWidget(
              stage: "4",
              stream: FirebaseFirestore.instance
                  .collection("class")
                  .doc("4")
                  .collection("${widget.uid}")
                  .snapshots(),
            ),
          ],
        ),
      ),
    );
  }
}
