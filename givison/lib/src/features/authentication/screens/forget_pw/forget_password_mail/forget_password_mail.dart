import 'package:flutter/material.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';
import 'package:givison/src/features/authentication/screens/forget_pw/forget_password_otp/forget_password_otp.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(171, 192, 176, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage(tForget), height: size.height * 0.4),
                Text(tForgetEmailTitle, style: Theme.of(context).textTheme.displayMedium),
                Text(tForgetEmailSubTitle, style: Theme.of(context).textTheme.titleSmall),
                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: tFormHeight - 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: tEmail,
                            hintText: tEmail,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                        width:double.infinity,
                        child: ElevatedButton(
                          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> OTP()));}, 
                          child: Text(tSubmit.toUpperCase())
                        ),
                      ),

                      ],
                    ),
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