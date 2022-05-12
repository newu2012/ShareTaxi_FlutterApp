import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FireUserDao extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future<String?> signup(String email, String password) async {
    var userCredentials;
    try {
      userCredentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (catchAuthExceptions(e) != null) rethrow;
    }

    return userCredentials.user?.uid;
  }

  Future<User?> login(String email, String password) async {
    var userCredentials;
    try {
      userCredentials = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (catchAuthExceptions(e) != null) rethrow;
    }

    return userCredentials.user;
  }

  FirebaseAuthException? catchAuthExceptions(e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    } else {
      print(e);
    }

    return e;
  }

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
