// ignore_for_file: empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:givison/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:givison/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:givison/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:givison/src/features/authentication/screens/dashboard/dashboard.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady(){
    firebaseUser = Rx<User?> (_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null? Get.offAll(()=> OnBoardingScreen()):Get.offAll(()=> const Dashboard());
  }

  Future<void> createUserWithEmailandPassword(String email, String password)async{
    try{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    firebaseUser.value!=null? Get.offAll(()=>const Dashboard()): Get.to(()=>const WelcomeScreen());
    } on FirebaseAuthException catch(e){
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      throw ex; 
    } catch(_){
      const ex = SignupWithEmailAndPasswordFailure();
      throw ex;
    }
  }

  Future<void> loginWithEmailandPassword(String email, String password)async{
    try{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    // ignore: unused_catch_clause
    } on FirebaseAuthException catch(e){
    } catch(_){}
  }

  Future<void> logout() async => await _auth.signOut();
}