
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  // Register new user
  Future<bool> signUp(AppUser user, String password) async {

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      // Create account in Firebase Authentication
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: user.email.trim(),
        password: password,
      );

      // Get Firebase UID
      String uid = credential.user!.uid;

      // Create user object with UID
      AppUser newUser = AppUser(
        uid: uid,
        name: user.name,
        email: user.email.trim(),
        createdAt: DateTime.now(),
      );

      // Save user data in Firestore
      await _firestore
          .collection('users')
          .doc(uid)
          .set(newUser.toMap());

      return true;

    } on FirebaseAuthException catch (e) {

      errorMessage = e.message;

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;
      notifyListeners();

    }

    return false;
  }

  // Login existing user
  Future<bool> signIn(String email, String password) async {

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      // Sign in using Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return true;

    } on FirebaseAuthException catch (e) {

      errorMessage = e.message;

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;
      notifyListeners();

    }

    return false;
  }

}
