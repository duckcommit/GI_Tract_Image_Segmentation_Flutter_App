import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:givison/src/repository/authentication_repository/authentication_repository.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  final email=TextEditingController();
  final password=TextEditingController();
  final fullName=TextEditingController();
  final phoneNo=TextEditingController();

  void registerUser(String email, String password){
    AuthenticationRepository.instance.createUserWithEmailandPassword(email, password);
  }
}