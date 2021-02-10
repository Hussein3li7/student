import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:student/Home/Home.dart';
import 'package:student/service/FirebaseService.dart';
import 'package:student/student/setStudentSingUp.dart';

class Login2 extends StatefulWidget {
  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: 'h@h.com', password: "111111");

    User user = userCredential.user;

    Stream<QuerySnapshot> stream = await FirebaseService().getAdminEmail();
    await stream.forEach((e) {
      for (var i in e.docs) {
        if (user.uid != i.id) {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (c) => SetStudentSingUp(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (c) => Home(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ECORP',
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
