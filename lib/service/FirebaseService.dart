import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  Future<FirebaseException> addNewClass(
      {String teacherName,
      String subName,
      String date,
      String time,
      int qrNumber,
      String uid,
      String stage,
      String type}) async {
    try {
      await FirebaseFirestore.instance
          .collection("class")
          .doc("$stage")
          .collection("$uid")
          .doc()
          .set({
        "teacherName": teacherName,
        "SubName": subName,
        "date": date,
        "time": time,
        "type": type,
        "qrNumber": qrNumber,
        "stage": stage
      });
      return FirebaseException(message: "Done", code: "Done", plugin: "Done");
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future<FirebaseException> addStudents(
      {String studentName,
      String subName,
      String date,
      String time,
      int qrNumber,
      String email,
      @required stage}) async {
    try {
      await FirebaseFirestore.instance
          .collection("storedStudents")
          .doc("$date")
          .collection("$qrNumber")
          .doc(email)
          .set({
        "studentName": studentName,
        "SubName": subName,
        "date": date,
        "time": time,
        "mark": 0,
        "stdEmail": email,
        "stage": stage
      });
      return FirebaseException(message: "Done", code: "Done", plugin: "Done");
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future<FirebaseException> addMarkToStudents(
      {String studentName,
      String subName,
      String date,
      String time,
      int qrNumber,
      int mark,
      String doc}) async {
    try {
      await FirebaseFirestore.instance
          .collection("storedStudents")
          .doc("$date")
          .collection("$qrNumber")
          .doc(doc)
          .update({"mark": mark ?? 0});
      return FirebaseException(message: "Done", code: "Done", plugin: "Done");
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future<FirebaseException> addTeacherAdminEmail(
      {String teacherAdminName, String email, String uid}) async {
    try {
      await FirebaseFirestore.instance
          .collection("TeacherAdminEmail")
          .doc(uid)
          .set({
        "teacherAdminEmail": teacherAdminName,
        "email": email,
        "admin": true,
      });
      return FirebaseException(message: "Done", code: "Done", plugin: "Done");
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future<Stream<QuerySnapshot>> getAdminEmail() async {
    return FirebaseFirestore.instance
        .collection("TeacherAdminEmail")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllStudentData({
    String stage,
    String stdtype,
  }) async {
    return FirebaseFirestore.instance
        .collection("allStudents")
        .doc(stage)
        .collection(stdtype)
        .snapshots();
  }

  Future<String> upluadStudent({
    String stage,
    String stdtype,
    String stdName,
    String email,
    String pass,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("allStudents")
          .doc(stage)
          .collection(stdtype)
          .doc(email)
          .set({
        "stdName": stdName,
        "stdEmail": email,
        "pass": pass,
        "stdtype": stdtype,
        "stage": stage,
        "admin": false,
      });
      return "Done";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
