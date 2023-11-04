import 'package:flutter/material.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';
import 'package:givison/src/features/authentication/screens/forget_pw/forget_password_mail/forget_password_mail.dart';
import 'package:givison/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:givison/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:givison/src/utils/utils.dart';
import 'package:givison/src/features/authentication/screens/dashboard/email.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final _formKey=GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    
  }

  void loginnn(){
    _auth.signInWithEmailAndPassword(email:emailController.text, password:passwordController.text).then((value){
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));

    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage(tLoginImg), height: size.height*0.4,),
                Text(tLoginTitle, style: Theme.of(context).textTheme.displayMedium,),
                Text(tLoginSubTitle, style: Theme.of(context).textTheme.titleSmall,),

                Form(
                  key:_formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: tFormHeight-10),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller:emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: tEmail,
                          hintText: tEmail,
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight-20,),
                      TextFormField(
                        controller:passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.fingerprint),
                          labelText: tPassword,
                          hintText: tPassword,
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(Icons.remove_red_eye_sharp)
                          ),
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight-20),
                      Align(alignment: Alignment.centerRight,child: TextButton(onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), 
                          builder:(context) => Container(
                          padding: const EdgeInsets.all(tDefaultSize),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(tForgetPasswordTitle, style:Theme.of(context).textTheme.displayMedium,),
                              Text(tForgetPasswordSubTitle, style:Theme.of(context).textTheme.titleSmall,),
                              const SizedBox(height: 60.0,),
                              GestureDetector(
                                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgetPasswordMailScreen()));},
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey.shade200
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.phone_android_outlined,size: 60.0,),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tmob, style:Theme.of(context).textTheme.displayMedium,),
                                        Text(tResetViaPh, style:Theme.of(context).textTheme.titleSmall,),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                              const SizedBox(height: 40.0,),
                              GestureDetector(
                                onTap: () {resetPassword();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EmailScreen()));},
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey.shade200
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.mail_outline_outlined,size: 60.0,),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tEmail, style:Theme.of(context).textTheme.displayMedium,),
                                        Text(tResetViaEmail, style:Theme.of(context).textTheme.titleSmall,),
                                      ],
                                    )
                                  ]),
                                ),
                              ),

                      
                            ]
                          ),
                        ),);
                      }, child: Text(tForgetPassword))),
                      SizedBox(
                        width:double.infinity,
                        child: ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              loginnn();
                            }
                          },
                          child: Text(tLogin.toUpperCase())
                        ),
                      ),
                      Align(alignment: Alignment.center,child: TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));}, child: Text.rich(TextSpan(
                        text: tNoAccount,
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(text:tSignup,style: TextStyle(color:Colors.blue)),
                        ])))),
                    ],),
                  ))
            ]),
          ),
        )),
    );
  }
  Future resetPassword()async{
    try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e){
      print(e);
    }
  }

}