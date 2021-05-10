import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/Home/generateNewLesson.dart';
import 'package:student/Home/homeWidget.dart';
import 'package:student/loginReg/StudentLogin.dart';
import 'package:student/service/FirebaseService.dart';
import 'package:student/studentAcountGenerator/studentAcountGenerator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController tcAdminPass = new TextEditingController();
  TextEditingController tcAdminName = new TextEditingController();
  GlobalKey<ScaffoldState> scaKey = new GlobalKey<ScaffoldState>();

  TextEditingController tcAdminEmail = new TextEditingController();
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
        FirebaseAuth.instance.signOut().then((x) {
          addNewAdmin = false;
          scaKey.currentState.showSnackBar(
            SnackBar(
              content: Text("تم انشاء الحساب بنجاح"),
            ),
          );
        });
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String userUid = '', email = '';
  Widget homeWidget;
  @override
  void initState() {
    super.initState();
    userUid = FirebaseAuth.instance.currentUser.uid;
    email = FirebaseAuth.instance.currentUser.email;
    homeWidget = HomeWidget(
      uid: userUid,
    );
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaKey,
      appBar: AppBar(
        title: Text("المحاضرات"),
        centerTitle: true,
        elevation: 0,
        actions: [
         email=="a@a.com"? IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await showAddNewAdmiDoalog();
            },
          ):Container(),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (c) {
                    return AlertDialog(
                      title: Text("تسجيل الخروج"),
                      content: Text("هل انت متاكد من تسجيل الخروج"),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("الغاء"),
                        ),
                        FlatButton(
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
                          child: Text("خروج"),
                        )
                      ],
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
        child: homeWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int i) {
          setState(() {
            index = i;
            if (i == 0) {
              homeWidget = HomeWidget(uid: userUid);
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
      floatingActionButton: RaisedButton.icon(
        label: Text(
          "محاضرة جديدة",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 10,
        color: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (c) => GenerateNewLesson(),
            ),
          );
        },
      ),
    );
  }
}
