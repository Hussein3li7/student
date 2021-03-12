import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student/loginReg/Register.dart';
import 'package:student/loginReg/TeacherLogin.dart';
import 'package:student/service/FirebaseService.dart';
import 'package:student/student/setStudentSingUp.dart';

class StudentLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentLoginUI();
  }
}

class StudentLoginUI extends State<StudentLogin> {
  GlobalKey<ScaffoldState> showSnak = GlobalKey<ScaffoldState>();

  TextEditingController userEmail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController resetEmailCtrl = TextEditingController();

  bool emailEmpty = false;
  bool passEmpty = false;
  bool badFormat = false;
  bool userNotFound = false;
  bool wrongPass = false;
  bool invalidEmail = false;
  bool publicError = false;

  bool showLoginLoding = false;

  String restEmailErrorCallPack = '';

  Future<void> restPassDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0.0,
          title: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'استعادة كلمة المرور',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              Center(
                child: Text(
                  restEmailErrorCallPack,
                  style: TextStyle(
                      fontFamily: 'Cairo', fontSize: 13.0, color: Colors.red),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontFamily: 'Cairo'),
                    controller: resetEmailCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xfff2eff5),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: Color(0xff393776), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50.0)),
                      hintText: 'الايميل',
                      labelText: 'الايميل',
                      labelStyle: TextStyle(color: Color(0xff393776)),
                      prefixIcon: Icon(
                        FontAwesomeIcons.solidUserCircle,
                        color: emailEmpty ? Colors.red : Color(0xff393776),
                      ),
                      prefixText: '',
                      hintStyle: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    color: Color(0xfffd9900),
                    onPressed: resteEmail,
                    child: Text(
                      'استعادة',
                      style:
                          TextStyle(fontFamily: 'Cairo', color: Colors.white),
                    ),
                  )),
            )
          ],
        );
      },
    );
  }

  Future resteEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmailCtrl.text.trim());
      snakbar("تم ارسال رابط تغير كلمة المرور الى الايميل");

      Navigator.of(context).pop();
    } catch (e) {
      snakbar("خطأ يرجى التاكد من الايميل او اتصالك بالشبكة");
    }
  }

  Future login(String email, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: pass.trim());

      User user = userCredential.user;

      Stream<QuerySnapshot> stream = await FirebaseService().getAdminEmail();
      await stream.forEach((e) async {
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
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (c) => StudentLogin(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }
      });
    } catch (e) {
      snakbar("خطأ يرجى التاكد من الايميل او اتصالك بالشبكة");
    }
  }

  bool showPass = true;

  enableShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  snakbar(String msg) async {
    showSnak.currentState.showSnackBar(SnackBar(
      content: Text("$msg"),
    ));
    setState(() {
      showLoginLoding = false;
    });
  }

  ///
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
///////////////////Start Build Ui  //////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
  Widget showLoading(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            animating: true,
            radius: 40.0,
          )
        : CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: showSnak,
      backgroundColor: Color(0xff393776),
      appBar: AppBar(
        title: Text(
          'تسجيل دخول كطالب',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((e) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (c) => TeacherLogin(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
/////////////////////////////// Start Input Filed for userEmail And Passwor

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: Text(
                            'اهلا بعودتك ',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontFamily: 'Cairo'),
                          ),
                        ),
                        Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  /// user Input Filed]
                                  padding: EdgeInsets.all(10.0),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextField(
                                      textDirection: TextDirection.ltr,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(fontFamily: 'Cairo'),
                                      controller: userEmail,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xfff2eff5),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xff393776),
                                              width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        errorText: emailEmpty
                                            ? 'هذا الحقل مطلوب'
                                            : invalidEmail
                                                ? 'الاميل غير صالح'
                                                : userNotFound
                                                    ? 'الايميل غير موجود'
                                                    : null,
                                        errorStyle:
                                            TextStyle(fontFamily: 'Cairo'),
                                        hintText: 'الايميل',
                                        labelText: 'الايميل',
                                        labelStyle:
                                            TextStyle(color: Color(0xff393776)),
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.solidUserCircle,
                                          color: emailEmpty
                                              ? Colors.red
                                              : Color(0xff393776),
                                        ),
                                        prefixText: '',
                                        hintStyle:
                                            TextStyle(fontFamily: 'Cairo'),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextField(
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(fontFamily: 'Cairo'),
                                      controller: pass,
                                      obscureText: showPass,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xfff2eff5),
                                        suffixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: IconButton(
                                              icon: Icon(
                                                showPass
                                                    ? FontAwesomeIcons.eyeSlash
                                                    : FontAwesomeIcons.eye,
                                                color: Color(0xff393776),
                                              ),
                                              onPressed: enableShowPass),
                                        ),
                                        errorText: passEmpty
                                            ? 'هذا الحقل مطلوب'
                                            : wrongPass
                                                ? 'الرمز السري خطأ'
                                                : null,
                                        errorStyle:
                                            TextStyle(fontFamily: 'Cairo'),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xff393776),
                                              width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        hintText: 'الرمز السري',
                                        labelText: 'الرمز السري',
                                        labelStyle:
                                            TextStyle(color: Color(0xff393776)),
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: passEmpty
                                              ? Colors.red
                                              : Color(0xff393776),
                                        ),
                                        prefixText: '',
                                        hintStyle:
                                            TextStyle(fontFamily: 'Cairo'),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(
                                        top: 10, right: 20, bottom: 10),
                                    child: InkWell(
                                      onTap: restPassDialog,
                                      child: Text(
                                        'هل نسيت كلمة المرور؟',
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 13.0,
                                            fontFamily: 'Cairo'),
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (userEmail.text.trim().isNotEmpty) {
                                          if (pass.text.trim().isNotEmpty) {
                                            showLoginLoding = true;
                                            passEmpty = false;

                                            login(userEmail.text, pass.text);
                                          } else {
                                            passEmpty = true;
                                            showLoginLoding = false;
                                          }
                                        } else {
                                          emailEmpty = true;
                                          showLoginLoding = false;
                                        }
                                      });
                                    },

                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Text(
                                          !showLoginLoding ? 'تسجيل دخول' : '',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 17.0),
                                        ),
                                        showLoginLoding
                                            ? showLoading(context)
                                            : Offstage(),
                                      ],
                                    ),
                                    color: Color(0xff393776),
                                    textColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10.0),
                                    // shape: BeveledRectangleBorder(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        //   Container(
                        //   margin: EdgeInsets.only(bottom: 20),
                        //   child:   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //         Container(
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(30.0),
                        //           color: Colors.black26,
                        //         ),
                        //         alignment: Alignment.centerLeft,
                        //         width: MediaQuery.of(context).size.width * 0.2,
                        //         height: 5.0,
                        //       ),
                        //         Container(
                        //         alignment: Alignment.center,
                        //         width: MediaQuery.of(context).size.width * 0.4,
                        //         height: 50.0,
                        //         color: Colors.transparent,
                        //         child:   Center(
                        //           child:   Text(
                        //             'او الدخول بواسطة',
                        //             style: TextStyle(
                        //                 color: Colors.black54,
                        //                 fontFamily: 'Cairo'),
                        //           ),
                        //         ),
                        //       ),
                        //         Container(
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(50.0),
                        //           color: Colors.black26,
                        //         ),
                        //         alignment: Alignment.centerRight,
                        //         width: MediaQuery.of(context).size.width * 0.2,
                        //         height: 5.0,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //   Container(
                        //   padding: EdgeInsets.only(bottom: 10.0),
                        //   alignment: Alignment.bottomCenter,
                        //   child:   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       Padding(
                        //         padding: EdgeInsets.only(right: 30, left: 30),
                        //         child: IconButton(
                        //             icon: Icon(
                        //               FontAwesomeIcons.twitter,
                        //               color: Colors.blue,
                        //               size: 50.0,
                        //             ),
                        //             onPressed: () {}),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.only(right: 30, left: 30),
                        //         child: IconButton(
                        //             icon: Icon(
                        //               FontAwesomeIcons.google,
                        //               color: Colors.yellow[800],
                        //               size: 50.0,
                        //             ),
                        //             onPressed: () {}),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.only(right: 30, left: 30),
                        //         child: IconButton(
                        //             icon: Icon(
                        //               FontAwesomeIcons.facebook,
                        //               color: Colors.blue[800],
                        //               size: 50.0,
                        //             ),
                        //             onPressed: () {}),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
