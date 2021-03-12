import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<FirebaseException> addNewClass({
    String teacherName,
    String subName,
    String date,
    String time,
    int qrNumber,
    String uid,
    String stage,
    String type
  }) async {
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
      String email}) async {
    try {
      await FirebaseFirestore.instance
          .collection("storedStudents")
          .doc("$date")
          .collection("$qrNumber")
          .doc()
          .set({
        "studentName": studentName,
        "SubName": subName,
        "date": date,
        "time": time,
        "mark": 0,
        "stdEmail": email,
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
          .doc()
          .set({
        "stdName": stdName,
        "stdEmail": email,
        "pass": pass,
        "stdtype": stdtype,
      });
      return "Done";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
