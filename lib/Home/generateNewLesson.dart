import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/class/class.dart';
import 'package:student/service/FirebaseService.dart';

class GenerateNewLesson extends StatefulWidget {
  GenerateNewLesson({Key key}) : super(key: key);

  @override
  _GenerateNewLessonState createState() => _GenerateNewLessonState();
}

class _GenerateNewLessonState extends State<GenerateNewLesson> {
  TextEditingController tchName = new TextEditingController();
  TextEditingController subName = new TextEditingController();
  GlobalKey<ScaffoldState> scaKey = new GlobalKey<ScaffoldState>();
  Random rnd = new Random();
  bool creating = false;

  User _user;
  Future addNewClassToFirebase() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      int randomNum = rnd.nextInt(999999);
      FirebaseService()
          .addNewClass(
        uid: _user.uid,
        type: stageType,
        stage: stageValue,
        teacherName: tchName.text,
        subName: subName.text,
        date: date,
        time: time,
        qrNumber: randomNum,
      )
          .then((st) {
        if (st.code == "Done") {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (c) => QRClass(
                tName: tchName.text,
                subName: subName.text,
                date: date,
                time: time,
                qrNumber: randomNum,
              ),
            ),
          );
          setState(() {
            creating = false;
          });
        } else {
          print(st);
          print("Error When add Data To FIrebase");
        }
      });
    }
  }

  String time;
  String date;
  Future createNewCalss() async {
    setClassDate();
    if (tchName != null && subName != null) {
      if (tchName.text.isNotEmpty && subName.text.isNotEmpty) {
        setState(() {
          creating = true;
        });
        addNewClassToFirebase();
      } else {
        print("Some Filed Is Empty");
      }
    }
  }

  setClassDate() {
    DateTime dateTime = DateTime.now();
    List spliteDate = dateTime.toString().split(" ");
    date = spliteDate[0];
    List timeDate = spliteDate[1].toString().split(".");
    time = timeDate[0];
  }

  String stageValue;
  String stageType;
  List<String> stageList = ["1", "2", "3", "4"];
  List<String> stageTypeList = ["صباحي", "مسائي"];
  Widget dropDownStageWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButton(
        value: stageValue,
        hint: Text(
          'المرحلة',
        ),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String v) {
          setState(() {
            stageValue = v;
          });
        },
        items: stageList.map<DropdownMenuItem<String>>((x) {
          return DropdownMenuItem<String>(
            value: x,
            child: Text("المرحلة $x"),
          );
        }).toList(),
      ),
    );
  }

  Widget dropDownStageTypeWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButton(
        value: stageType,
        hint: Text(
          'نوع الدراسة',
        ),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String v) {
          setState(() {
            stageType = v;
          });
        },
        items: stageTypeList.map<DropdownMenuItem<String>>((x) {
          return DropdownMenuItem<String>(
            value: x,
            child: Text("$x"),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("انشاء محاضرة جديدة"),
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
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  dropDownStageWidget(),
                  dropDownStageTypeWidget(),
                ],
              ),
              Text(
                "انشاء محاضرة جديدة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CupertinoTextField(
                controller: tchName,
                padding: EdgeInsets.all(16),
                placeholder: "اسم الاستاذ",
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              CupertinoTextField(
                controller: subName,
                placeholder: "اسم المادة",
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width / 1.2,
                child: RaisedButton(
                  color: creating ? Colors.yellow : Colors.green.shade500,
                  child: creating
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "انشاء درس جديد",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  onPressed: createNewCalss,
                ),
              ),
              SizedBox(
                height: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
