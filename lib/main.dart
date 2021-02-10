import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/Home/Home.dart';
import 'package:student/loginReg/StudentLogin.dart';
import 'package:student/loginReg/TeacherLogin.dart';
import 'package:student/service/FirebaseService.dart';
import 'package:student/student/setStudentSingUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool studentLogin = false, techerLogin = false;
  @override
  void initState() {
    super.initState();
    getLoginState();
  }

  Widget homeWidget = StudentLogin();
  User user;
  getLoginState() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Stream<QuerySnapshot> stream = await FirebaseService().getAdminEmail();
      stream.forEach((e) {
        for (var i in e.docs) {
          if (user.uid.contains(i.id)) {
            setState(() {
              homeWidget = Home();
            });
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   CupertinoPageRoute(
            //     builder: (c) => Home(),
            //   ),
            //   (Route<dynamic> route) => false,
            // );
          } else {
            setState(() {
              homeWidget = StudentLogin();
            });
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   CupertinoPageRoute(
            //     builder: (c) => SetStudentSingUp(),
            //   ),
            //   (Route<dynamic> route) => false,
            // );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'تسجيل الطلبة',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff393776),
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            color: Color(0xff393776),
          ),
        ),
        home: homeWidget
        // home: studentLogin //Check If user is A Student or No
        //     ? SetStudentSingUp()
        //     : techerLogin //check If user Teacher or No
        //         ? Home()
        //         : TeacherLogin()
        );
  }
}
