import 'package:flutter/material.dart';
import 'package:givison/src/constants/colors.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';
import 'package:givison/src/features/authentication/screens/login/login_screen.dart';
import 'package:givison/src/features/authentication/screens/signup/signup_screen.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({Key? key}): super(key:key);

  
  @override
  Widget build(BuildContext context){
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 230, 239, 1),
      body:Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(tWelcomeScreenImage), height:height*0.6),
            Column(
              children: [
                Text(tWelcomeTitle, style: Theme.of(context).textTheme.displayMedium,textAlign: TextAlign.center,),
                Text(tWelcomeSubTitle, style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center,),
              ],
            ),
            Row(
              children: [
              Expanded(child: OutlinedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                }, 
                
                child: Text(tLogin.toUpperCase())
              ),
            ),
              SizedBox(width: 10.0,),
              Expanded(child: ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));}, 
              style:OutlinedButton.styleFrom(
                elevation: 0,
                  shape: RoundedRectangleBorder(),
                  foregroundColor: tWhiteColor,
                  backgroundColor: tSecondaryColor,
                  side: BorderSide(color: tSecondaryColor),
                  padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                ),
                child: Text(tSignup.toUpperCase()))),
              ],
            ),
          ],
        ),
      ),    
    );
  }
}