import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<FirebaseAuthException> login({String email, String pass}) async {
    try {
      UserCredential user1 = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    return FirebaseAuthException(message: "Login_Done");
  
    } on FirebaseAuthException catch (e) {
      return e;
    } 

  }

  Future<User> regesterNewUser({String email, String pass}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((d) {
        User user = d.user;
        return user;
      });
    } catch (e) {
      return e;
    }
    return null;
  }

  Future<FirebaseAuthException> resetPass({String email}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((_) {
        return FirebaseAuthException(message: "Email_Sended");
      });
    } on FirebaseAuthException catch (e) {
      return e;
    }
    return null;
  }
}
