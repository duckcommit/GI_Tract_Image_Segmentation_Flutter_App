import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:givison/common/size.dart';
import 'package:givison/common/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:givison/common/text_styles.dart';
import 'package:givison/common/toastMessage.dart';
import 'package:givison/screens/signup/verify_email.screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phController = TextEditingController();
  final nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection("users");

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginn() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Verify()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }

  void uploadingData() async {
    await FirebaseFirestore.instance.collection("Users").add({
      'Name': nameController.text.toString(),
      'E-mail': emailController.text.toString(),
      'Phone Number': phController.text.toString(),
      'Pw': passwordController.text.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  tSignupTitle,
                  style: TextStyles.blackTitle
                ),
                const SizedBox(height: 8),
                const Text(
                  tSignupSubTitle,
                  style: TextStyles.blackSubTitle
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: const Icon(
                            Ionicons.person,
                            color: Colors.black,
                          ),
                          labelText: tFullName,
                          hintText: tFullName,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Ionicons.mail),
                          labelText: tEmail,
                          hintText: tEmail,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Ionicons.call),
                          labelText: tPhoneNo,
                          hintText: tPhoneNo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Valid Phone Number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Ionicons.finger_print),
                          labelText: tPassword,
                          hintText: tPassword,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String email = emailController.text;
                              if (email.contains('@iiitm.ac.in')) {
                                loginn();
                                String name = nameController.text;
                                String ph = phController.text;
                                String pw = passwordController.text;
                                fireStore
                                    .doc(email)
                                    .set({
                                      'Name': name,
                                      'Email': email,
                                      'Phone': ph,
                                      'Password': pw
                                    })
                                    .then((value) {})
                                    .onError((error, stackStrace) {
                                      Utils().toastMessage(error.toString());
                                    });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Not the Organization Mail");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            tSignupButton,
                            style: TextStyles.loginButton
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Center(
                        child: Text.rich(
                          TextSpan(
                            text: tTnctitle,
                            style: TextStyles.blackloginLink,
                            children: [
                              TextSpan(
                                text: tTnc,
                                style: TextStyles.blackloginLinkHighlighted,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
