import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student/student/setStudentSingUp.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegisterUI();
  }
}

class RegisterUI extends State<Register> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController studentNameCtrl = TextEditingController();
  bool emailEmpty = false;
  bool passEmpty = false;
  bool badFormat = false;
  bool userNotFound = false;
  bool wrongPass = false;
  bool invalidEmail = false;
  bool publicError = false;
  bool userAlreadyUserd = false;
  bool showPass = true;
  bool showLoginLoding = false;
  bool nameEmpty = false;
  enableShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  Future registerNowUser(
      {String email, String pass, String studentName}) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: pass.trim());
      User userProfile = user.user;
      await userProfile.updateProfile(displayName: studentNameCtrl.text);
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (c) => SetStudentSingUp(),
        ),
      );
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (c) => Home(),
      //   ),
      // );
    } catch (e) {
      if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
        setState(() {
          userNotFound = true;
          showLoginLoding = false;
          wrongPass = false;
          invalidEmail = false;
          publicError = false;
        });
      } else if (e.toString().contains('ERROR_WRONG_PASSWORD')) {
        setState(() {
          wrongPass = true;
          showLoginLoding = false;
          invalidEmail = false;
          userNotFound = false;
          publicError = false;
        });
      } else if (e.toString().contains('ERROR_INVALID_EMAIL')) {
        setState(() {
          invalidEmail = true;
          showLoginLoding = false;
          wrongPass = false;
          userNotFound = false;
          publicError = false;
        });
      } else if (e.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        setState(() {
          userAlreadyUserd = true;
          invalidEmail = false;
          showLoginLoding = false;
          wrongPass = false;
          userNotFound = false;
          publicError = false;
        });
      } else {
        setState(() {
          publicError = true;
          showLoginLoding = false;
        });
      }
    }
  }

  Widget showLoading(BuildContext context) {
    return Platform.isIOS
        ? new CupertinoActivityIndicator(
            animating: true,
            radius: 40.0,
          )
        : new CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff393776),
      body: SafeArea(
        child: Container(
          child: new Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.topCenter,
                height: 100.0,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(left: 20, bottom: 10),
                      child: new Text(
                        'انشاء حساب',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                    new Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(bottom: 10, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/Login');
                              },
                              child: new Text(
                                ' تسجيل دخول ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Text(
                              ' تمتلك حساب؟ ',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),

/////////////////////////////// Start Input Filed for Username And Passwor

              Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                    color: Colors.white,
                  ),
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: new Text(
                            'اهلاً بك ',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        new Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  /// user Input Filed
                                  padding: EdgeInsets.all(10.0),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: new TextField(
                                      keyboardType: TextInputType.text,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(),
                                      controller: studentNameCtrl,
                                      decoration: new InputDecoration(
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
                                        errorText: nameEmpty
                                            ? 'هذا الحقل مطلوب'
                                            : null,
                                        errorStyle: TextStyle(),
                                        hintText: 'الاسم',
                                        labelText: 'الاسم',
                                        labelStyle:
                                            TextStyle(color: Color(0xff393776)),
                                        prefixIcon: new Icon(
                                          FontAwesomeIcons.solidUserCircle,
                                          color: nameEmpty
                                              ? Colors.red
                                              : Color(0xff393776),
                                        ),
                                        prefixText: '',
                                        hintStyle: TextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
///////////////////////////////////////////////////////////////////////////////////////////////////
                                new Container(
                                  /// user Input Filed
                                  padding: EdgeInsets.all(10.0),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: new TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(),
                                      controller: userEmail,
                                      decoration: new InputDecoration(
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
                                                    : userAlreadyUserd
                                                        ? 'الايميل مستخدم بالفعل'
                                                        : null,
                                        errorStyle: TextStyle(),
                                        hintText: 'الايميل',
                                        labelText: 'الايميل',
                                        labelStyle:
                                            TextStyle(color: Color(0xff393776)),
                                        prefixIcon: new Icon(
                                          FontAwesomeIcons.solidUserCircle,
                                          color: emailEmpty
                                              ? Colors.red
                                              : Color(0xff393776),
                                        ),
                                        prefixText: '',
                                        hintStyle: TextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: new TextField(
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(),
                                      controller: pass,
                                      obscureText: showPass,
                                      decoration: new InputDecoration(
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
                                            onPressed: enableShowPass,
                                          ),
                                        ),
                                        errorText: passEmpty
                                            ? 'هذا الحقل مطلوب'
                                            : wrongPass
                                                ? 'الرمز السري خطأ'
                                                : null,
                                        errorStyle: TextStyle(),
                                        hintText: 'الرمز السري',
                                        labelText: 'الرمز السري',
                                        labelStyle:
                                            TextStyle(color: Color(0xff393776)),
                                        prefixIcon: new Icon(
                                          FontAwesomeIcons.lock,
                                          color: passEmpty
                                              ? Colors.red
                                              : Color(0xff393776),
                                        ),
                                        prefixText: '',
                                        hintStyle: TextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  alignment: Alignment.center,
                                  child: new RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (studentNameCtrl.text != null &&
                                            studentNameCtrl.text.isNotEmpty) {
                                          if (userEmail.text
                                              .trim()
                                              .isNotEmpty) {
                                            if (pass.text.trim().isNotEmpty) {
                                              showLoginLoding = true;
                                              passEmpty = false;
                                              registerNowUser(
                                                studentName:
                                                    studentNameCtrl.text,
                                                email: userEmail.text,
                                                pass: pass.text,
                                              );
                                            } else {
                                              passEmpty = true;
                                              showLoginLoding = false;
                                            }
                                          } else {
                                            emailEmpty = true;
                                            showLoginLoding = false;
                                          }
                                        } else {
                                          setState(() {
                                            nameEmpty = true;
                                          });
                                        }
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        new Text(
                                          !showLoginLoding ? 'انشاء حساب' : '',
                                          style: TextStyle(fontSize: 17.0),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // child: new Container(
      //   padding: EdgeInsets.all(10.0),
      //   child: new Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       new Container(

      //         padding: EdgeInsets.only(
      //             left: 5.0, right: 3.6, top: 20.0, bottom: 10.0),
      //         alignment: Alignment.topCenter,
      //         color: Colors.black12,
      //         child: new Text('Hussein'),
      //       ),
      //       new Container(

      //         padding: EdgeInsets.only(
      //             left: 5.0, right: 3.6, top: 20.0, bottom: 10.0),
      //         color: Colors.redAccent.shade700,
      //         alignment: Alignment.centerRight,
      //         child: new Text('Hussein2'),
      //       ),
      //       new Container(

      //         padding: EdgeInsets.only(
      //             left: 5.0, right: 3.6, top: 20.0, bottom: 10.0),
      //         color: Colors.yellowAccent.shade700,
      //         alignment: Alignment.centerLeft,
      //         child: new Text('Hussein3'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
