import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart'; 

class OTP extends StatelessWidget {
  const OTP({Key? key}):super(key:key);

  @override
  
  Widget build(BuildContext context){
    final size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(171, 192, 176, 1),
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(totp), height:size.height*0.3),
            Text(tOTP,style:Theme.of(context).textTheme.displayMedium,),
            Text(tOTPsub,style:Theme.of(context).textTheme.titleSmall,),
            const SizedBox(height: 40.0,),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code){print("OTP is $code");},
            ),
            const SizedBox(height: 20.0,),
            SizedBox(
              width:double.infinity,
              child: ElevatedButton(onPressed: (){}, child: const Text(tSubmit))),

          ],)
      )
    );
  }
}