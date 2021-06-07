import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:student/widget/setNewStudentStreamWidget.dart';

// ignore: must_be_immutable
class ShowStoredClassQrCode extends StatefulWidget {
  String tName, subName, date, time,stageType;
  int qrNumber,stage;
  ShowStoredClassQrCode(
      {this.subName, this.tName, this.date, this.time, this.qrNumber,this.stage,this.stageType});
  @override
  _ShowStoredClassQrCodeState createState() => _ShowStoredClassQrCodeState();
}

class _ShowStoredClassQrCodeState extends State<ShowStoredClassQrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              centerTitle: true,
              pinned: true,
              floating: true,
              expandedHeight: 300.0,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(30.0),
              //     bottomRight: Radius.circular(30.0),
              //   ),
              // ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: QrImage(
                    data:
                        "${widget.tName}#${widget.subName}#${widget.date}#${widget.time}#${widget.qrNumber.toString()}#${widget.stage}#${widget.stageType}",
                    errorStateBuilder: (c, o) {
                      return Text("Errror $o");
                    },
                  ),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(30.0),
                        //   topRight: Radius.circular(30.0),
                        // ),
                      ),
                      child: SetNewStudentStreamWidget(
                        stream: FirebaseFirestore.instance
                            .collection("storedStudents")
                            .doc(widget.date)
                            .collection("${widget.qrNumber}")
                            .snapshots(),
                        qrNumber: widget.qrNumber,
                        context2: context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
