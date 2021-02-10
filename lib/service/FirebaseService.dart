import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<FirebaseException> addNewClass(
      {String teacherName,
      String subName,
      String date,
      String time,
      int qrNumber}) async {
    try {
      await FirebaseFirestore.instance.collection("class").doc().set({
        "teacherName": teacherName,
        "SubName": subName,
        "date": date,
        "time": time,
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
      String uid}) async {
    try {
      await FirebaseFirestore.instance
          .collection("storedStudents")
          .doc("$date")
          .collection("$qrNumber")
          .doc(uid)
          .set({
        "studentName": studentName,
        "SubName": subName,
        "date": date,
        "time": time,
        "mark": 0
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
      {String teacherAdminName, String email,String uid}) async {
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
}
