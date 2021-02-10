import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/Home/homeWidget.dart';
import 'package:student/class/class.dart';
import 'package:student/loginReg/StudentLogin.dart';
import 'package:student/loginReg/TeacherLogin.dart';
import 'package:student/service/FirebaseService.dart';
import 'package:student/studentAcountGenerator/studentAcountGenerator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController tchName = new TextEditingController();
  TextEditingController subName = new TextEditingController();
  TextEditingController tcAdminEmail = new TextEditingController();
  TextEditingController tcAdminPass = new TextEditingController();
  TextEditingController tcAdminName = new TextEditingController();
  GlobalKey<ScaffoldState> scaKey = new GlobalKey<ScaffoldState>();
  Random rnd = new Random();

  Future addNewClassToFirebase() async {
    int randomNum = rnd.nextInt(999999);
    FirebaseService()
        .addNewClass(
            teacherName: tchName.text,
            subName: subName.text,
            date: date,
            time: time,
            qrNumber: randomNum)
        .then((st) {
      if (st.code == "Done") {
        print(st);
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
      } else {
        print(st);
        print("Error When add Data To FIrebase");
      }
    });
  }

  String time;
  String date;
  Future createNewCalss() async {
    setClassDate();
    if (tchName != null && subName != null) {
      if (tchName.text.isNotEmpty && subName.text.isNotEmpty) {
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
    print(spliteDate);
    print(date);
    print(time);
  }

  Future createClassInfoDialog() async {
    await showDialog(
      context: context,
      builder: (c) {
        return StatefulBuilder(
          builder: (c, setState2) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: Text(
                  "انشاء محاضرة جديدة",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      placeholder: "اسم المحاضرة",
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
                  ],
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
                      createNewCalss();
                    },
                    child: Text("انشاء"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool addNewAdmin = false;

  Future showAddNewAdmiDoalog() async {
    await showDialog(
      context: context,
      builder: (c) {
        return StatefulBuilder(
          builder: (BuildContext context, setState2) {
            return AlertDialog(
              title: Text(
                "اظافة استاذ جديد",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoTextField(
                    controller: tcAdminName,
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
                    controller: tcAdminEmail,
                    padding: EdgeInsets.all(16),
                    placeholder: "الايميل",
                    keyboardType: TextInputType.emailAddress,
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
                    controller: tcAdminPass,
                    placeholder: "الرقم السري",
                    padding: EdgeInsets.all(16),
                    obscureText: true,
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
                ],
              ),
              actions: addNewAdmin
                  ? [
                      CircularProgressIndicator(),
                    ]
                  : [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("الغاء"),
                      ),
                      FlatButton(
                        onPressed: () async {
                          setState2(() {
                            addNewAdmin = true;
                          });
                          await createNewAdminAccount();
                        },
                        child: Text("انشاء الحساب"),
                      )
                    ],
            );
          },
        );
      },
    );
  }

  Future createNewAdminAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: tcAdminEmail.text, password: tcAdminPass.text);
      User user = userCredential.user;
      await user.updateProfile(displayName: tcAdminPass.text);
      await FirebaseService()
          .addTeacherAdminEmail(
              email: tcAdminEmail.text,
              teacherAdminName: tcAdminName.text,
              uid: user.uid)
          .then((s) {
        addNewAdmin = false;
        Navigator.of(context).pop();
        scaKey.currentState.showSnackBar(
          SnackBar(
            content: Text("تم انشاء الحساب بنجاح"),
          ),
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }

  int index = 0;
  Widget homeWidget = HomeWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaKey,
      appBar: AppBar(
        title: Text("المحاضرات"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await showAddNewAdmiDoalog();
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((e) {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (c) => StudentLogin(),
                  ),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          alignment: Alignment.topCenter,
          child: homeWidget),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int i) {
          setState(() {
            index = i;
            if (i == 0) {
              homeWidget = HomeWidget();
            } else if (i == 1) {
              homeWidget = StudentAcountGenerator();
            }
          });
        },
        backgroundColor: Color(0xff393776),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade200,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            activeIcon: CircleAvatar(
              child: Icon(
                Icons.home,
              ),
              backgroundColor: Colors.white,
            ),
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            activeIcon: CircleAvatar(
              child: Icon(
                CupertinoIcons.add_circled_solid,
              ),
              backgroundColor: Colors.white,
            ),
            icon: Icon(CupertinoIcons.add_circled_solid),
            label: "انشاء حسابات",
            backgroundColor: Colors.white,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: createClassInfoDialog,
      ),
    );
  }
}
