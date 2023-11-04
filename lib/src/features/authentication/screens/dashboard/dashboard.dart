import "package:flutter/material.dart";
import "package:givison/src/constants/colors.dart";
import "package:givison/src/constants/image_strings.dart";
import "package:givison/src/constants/size.dart";
import "package:givison/src/constants/text_strings.dart";
import 'package:givison/src/features/authentication/screens/dashboard/profile.dart';
import 'package:givison/src/repository/authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:givison/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:givison/src/features/authentication/screens/dashboard/error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:givison/src/features/authentication/screens/dashboard/DataModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:givison/src/features/authentication/screens/dashboard/profile.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({Key? key}): super(key: key);

  
  @override
  State<Dashboard> createState()=> _DashboardState();
}

Future<DataModel> submitData(String imageUrl)async{
  
  final uri = Uri.parse('http://4.154.41.19:8000/predict');
    Map<String,String> headers = {'Content-Type':'application/json'};
final msg = jsonEncode({"image": imageUrl});

  var response = await http.post(uri, 
  body: msg,
  headers:headers
  );
  print(imageUrl);
  var data = response.body;
  var jsonData = json.decode(response.body);
  var key="image_url";
  var valueVar = jsonData[key];
  //downloadfile(valueVar);
  var time=DateTime.now().millisecondsSinceEpoch;
  var path = "/storage/emulated/0/Download/image-$time.png";
  var file =File(path);
  var res = await http.get(Uri.parse(valueVar));
  file.writeAsBytes(res.bodyBytes);
  if (response.statusCode==200){
    String responseString = response.body;
    return dataModelFromJson(responseString);
  }
  String responseString = "";
  return dataModelFromJson(responseString);
}

class _DashboardState extends State<Dashboard>{
  final _auth = FirebaseAuth.instance;
  DataModel? _dataModel; 
  File? image;
  String imageUrl='';

  bool isloading=false;

  @override
  Widget build(BuildContext context){
    final size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: ClickableIcon(),
        title: Text(tAppNameBar, style: Theme.of(context).textTheme.displayMedium),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: tCardBgColor),
            child: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));},
            icon: const Image(image: AssetImage(tman))),
          )
        ]
      ),
      body:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDashboardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(tDashboardTitleMain, style:Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: tDashboardPadding*1),
              Text(tDashboardTitle, style:Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: tDashboardPadding*2),
              Image(image: AssetImage(tupload), height: size.height*0.4,),
              SizedBox(
                        width:double.infinity,
                        child: ElevatedButton(
                          onPressed: ()async{
                            
                            ImagePicker imagePicker=ImagePicker();
                            final image = await imagePicker.pickImage(source:ImageSource.gallery);
                            if (image ==null) return;
                            print("Hi");
                            final imageTemporary = File(image.path);
                            String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
                            Reference referenceRoot=FirebaseStorage.instance.ref();
                            Reference referenceDirImages=referenceRoot.child("images");
                            Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);

                            try{
                            await referenceImageToUpload.putFile(File(image.path));
                            imageUrl=await referenceImageToUpload.getDownloadURL();
                            print("Hi");
                            print(imageUrl);
                            
                            }catch(error){

                            };
                          }, 
                          child: Text(tUpload.toUpperCase())
                        ),
                      ),
              const SizedBox(height: tDashboardPadding*2),       
              SizedBox(
                        width:double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(onSurface: Colors.blue,),
                          onPressed: ()async{
                            if (imageUrl.length==0){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ErrorScreen()));
                              isloading=false;
                            }
                            else{
                              setState((){
                              isloading=true;
                              });
                              Future.delayed(Duration(seconds: 20),(){
                                setState((){
                              isloading=false;
                              });
                              Fluttertoast.showToast(msg: "Downloaded!");
                              });
                        
                              final DataModel data = await submitData(imageUrl);

                              setState((){
                              _dataModel = data;
                              });
                              
                              
          
                            };
                          },
                          child: isloading? CircularProgressIndicator(color:Colors.white):Text(tSegment.toUpperCase())
                        ),
                      ),
            ]
          )
        ),
      )  
    );
  }
}

class ClickableIcon extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        auth.signOut().then((value){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> OnBoardingScreen()));
        });
      },
      child: const Icon(
        Icons.logout,
        color: Colors.black,
      ),
    );
  }
}