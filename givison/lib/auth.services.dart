import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:givison/common/toastMessage.dart';
import 'package:givison/screens/dashboard/dashboard.screen.dart';
import 'package:givison/screens/on_boarding/on_boarding.screen.dart';
import 'package:givison/screens/signup/verify_email.screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup(BuildContext context, String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Verify()),
      );
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'Name': name,
        'Email': email,
        'Phone': phone,
        'Password': password,
      });
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message!);
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Utils().toastMessage(userCredential.user!.email.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message!);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> uploadingData(String name, String email, String phone, String password) async {
    await _firestore.collection("Users").add({
      'Name': name,
      'E-mail': email,
      'Phone Number': phone,
      'Pw': password,
    });
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message!);
    }
  }
}
