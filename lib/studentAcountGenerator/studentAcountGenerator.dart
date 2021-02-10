import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentAcountGenerator extends StatefulWidget {
  StudentAcountGenerator({Key key}) : super(key: key);
  BuildContext context;

  @override
  _StudentAcountGeneratorState createState() => _StudentAcountGeneratorState();
}

class _StudentAcountGeneratorState extends State<StudentAcountGenerator> {
  TextEditingController stName = TextEditingController();
  TextEditingController stEmail = TextEditingController();
  TextEditingController stPass = TextEditingController();
  bool loading = false, textFieldEmpty = false;
  GlobalKey<ScaffoldState> scaKey;
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String pass_chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#%^&*()_+';
  Random _rnd = Random();

  String getRandomString(int length, String string) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => string.codeUnitAt(
            _rnd.nextInt(string.length),
          ),
        ),
      );

  String createRandomEmail() {
    stEmail.text = "${getRandomString(10, _chars)}@uodiyala.edu.iq";
    return stEmail.text;
  }

  String createRandomPass() {
    return stPass.text = getRandomString(8, pass_chars);
  }

  Future createAccount() async {
    if (stEmail != null && stPass != null && stName != null) {
      if (stEmail.text.isNotEmpty &&
          stPass.text.isNotEmpty &&
          stName.text.isNotEmpty) {
        setState(() {
          loading = true;
          textFieldEmpty = false;
        });
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: stEmail.text, password: stPass.text);
          User user = userCredential.user;
          user.updateProfile(displayName: stName.text).then((u) {
            FirebaseAuth.instance.signOut().then((e) async {
              setState(() {
                loading = false;
              });
              stEmail.clear();
              stPass.clear();
              stName.clear();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("تم انشاء الحساب بنجاح"),
                backgroundColor: Colors.green.shade600,
                duration: Duration(minutes: 10),
              ));
            });
          });
        } on FirebaseAuthException catch (e) {
          print(" Message is ======== ${e.message}");
        }
      } else {
        setState(() {
          textFieldEmpty = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaKey,
      appBar: AppBar(
        title: Text("انشاء حساب الطلاب"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFieldEmpty
                    ? Text(
                        "بعض الحقول فارغة",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    : Offstage(),
                SizedBox(
                  height: 7,
                ),
                CupertinoTextField(
                  controller: stName,
                  padding: EdgeInsets.all(16),
                  placeholder: "اسم الطالب",
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
                TextField(
                  controller: stEmail,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: createRandomEmail,
                      icon: Icon(Icons.attach_email_rounded),
                    ),
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errordBorder,
                    labelText: "الايميل",
                    hintText: "الايميل",
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                TextField(
                  controller: stPass,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: createRandomPass,
                      icon: Icon(Icons.lock),
                    ),
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errordBorder,
                    labelText: "الرقم السري",
                    hintText: "الرقم السري",
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    child: loading
                        ? CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            "انشاء حساب",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    onPressed: createAccount,
                    color: Color(0xff393776),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade400,
      width: 1,
    ),
  );
  InputBorder enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade400,
      width: 1,
    ),
    // borderSide: BorderSide(
    //   color: Colors.grey.shade200,
    //   width: 1,
    // ),
  );
  InputBorder errordBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red.shade700,
      width: 1,
    ),
  );
}
