import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';
import 'package:givison/src/features/authentication/controllers/signup_controller.dart';
import 'package:givison/src/features/authentication/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:givison/src/utils/utils.dart';
import 'package:givison/src/features/authentication/screens/dashboard/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}):super(key:key);
  
  @override
  State<ProfileScreen> createState()=> _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen>{
  bool loading= false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String? Email;
  String? phno;
  String? pw;
  String? Name;
  

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  
void getData()async{
    User? user = _auth.currentUser;
    Email = user!.email!;
    
    
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(Email).get();
    name =userDoc.get("Name");
    Name=name.toString();
    phno =userDoc.get("Phone Number");
    pw =userDoc.get("Pw");
}

_launchURL() async {
   final Uri url = Uri.parse('mailto:puthen1977@gmail.com');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch');
    }
}
  
  @override
  
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        
        appBar: AppBar(
        title: Text(tprofile, style: Theme.of(context).textTheme.displayMedium),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: tCardBgColor),
            child: IconButton(onPressed: (){getData();},
            icon: const Image(image: AssetImage(tman))),
          )
        ]
      ),
        backgroundColor: Color.fromRGBO(184, 190, 221, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage(tprof), height: size.height*0.37,),

                Form(
                  
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: tFormHeight-10),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        readOnly: true,
                        initialValue: 'Vyshnav',
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: tFullName,
                          hintText: tFullName,
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight-20,),
                      TextFormField(
                        initialValue: 'bcs_2021076@gmail.com',
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline_outlined),
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
                        initialValue: '8129462042',
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_callback_outlined),
                          labelText: tPhoneNo,
                          hintText: tPhoneNo,
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Valid Phone Number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight-20,),
                      TextFormField(
                        initialValue: 'abcdef',
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.fingerprint),
                          labelText: tPassword,
                          hintText: tPassword,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter the password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight-20),
                      
                      Align(alignment: Alignment.center,child: TextButton(onPressed: (){_launchURL();}, child: Text.rich(TextSpan(
                        text: tedit,
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(text:treq,style: TextStyle(color:Colors.blue)),
                        ])))),
                    ],),
                  ))
            ]),
          ),
        )),
    );
  }
}