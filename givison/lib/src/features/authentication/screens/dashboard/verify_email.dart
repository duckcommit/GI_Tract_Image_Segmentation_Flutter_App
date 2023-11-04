import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:givison/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:givison/src/constants/colors.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}):super(key:key);
  
  @override
  
  State<Verify> createState()=> _VerifyState();
}

class _VerifyState extends State<Verify>{
  bool isEmailVerified=false;
  late Timer _timer;

  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      _timer = Timer.periodic(
        Duration(seconds:3),
        (timer)=>checkEmailVerified(),
      );
    }
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  Future checkEmailVerified()async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState((){
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      _timer.cancel();
  }
  }

  Future sendVerificationEmail()async{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context)=>isEmailVerified
    ? Dashboard()
    : Scaffold(
      backgroundColor: Color.fromRGBO(184, 190, 221, 1),
      body:Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(tver)),
            Column(
              children: [
                Text(tVerifyTitle, style: Theme.of(context).textTheme.displayMedium,textAlign: TextAlign.center,),
                Text(tVerifySTitle, style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center,),
              ],
            ),
          ],
        ),
      ),
    );
}