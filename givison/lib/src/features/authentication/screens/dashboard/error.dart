import 'package:flutter/material.dart';
import 'package:givison/src/constants/colors.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';
import 'package:givison/src/features/authentication/screens/login/login_screen.dart';
import 'package:givison/src/features/authentication/screens/signup/signup_screen.dart';

class ErrorScreen extends StatelessWidget{
  const ErrorScreen({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(184, 190, 221, 1),
      body:Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(tno), height:height*0.6),
            Column(
              children: [
                Text(tErrorTitle, style: Theme.of(context).textTheme.displayMedium,textAlign: TextAlign.center,),
                Text(tErrorSubTitle, style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}