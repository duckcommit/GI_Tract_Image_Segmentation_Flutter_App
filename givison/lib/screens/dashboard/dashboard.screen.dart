import 'package:flutter/material.dart';
import 'package:givison/common/colors.dart';
import 'package:givison/common/image_strings.dart';
import 'package:givison/common/size.dart';
import 'package:givison/common/text_strings.dart';
import 'package:givison/common/text_styles.dart';
import 'package:givison/screens/on_boarding/on_boarding.screen.dart';
import 'package:givison/screens/dashboard/error.screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:givison/models/datamodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

Future<DataModel> submitData(String imageUrl) async {
  final uri = Uri.parse('http://4.154.41.19:8000/predict');
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final msg = jsonEncode({"image": imageUrl});

  var response = await http.post(uri, body: msg, headers: headers);
  var jsonData = json.decode(response.body);
  var key = "image_url";
  var valueVar = jsonData[key];
  var time = DateTime.now().millisecondsSinceEpoch;
  var path = "/storage/emulated/0/Download/image-$time.png";
  var file = File(path);
  var res = await http.get(Uri.parse(valueVar));
  file.writeAsBytes(res.bodyBytes);
  if (response.statusCode == 200) {
    String responseString = response.body;
    return dataModelFromJson(responseString);
  }
  String responseString = "";
  return dataModelFromJson(responseString);
}

class _DashboardState extends State<Dashboard> {
  DataModel? _dataModel;
  File? image;
  String imageUrl = '';

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: ClickableIcon(),
        title: const Text(
          tAppNameBar,
          style: TextStyles.blackTitle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDashboardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                tDashboardTitleMain,
                style: TextStyles.blackTitle,
              ),
              const SizedBox(height: 20),
              const Text(
                tDashboardTitle,
                style: TextStyles.blackSubTitle,
              ),
              const SizedBox(height: 30),
              Image(
                image: const AssetImage(tupload),
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    final image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image == null) return;

                    // Check if the selected file is not a .png
                    if (!image.path.toLowerCase().endsWith('.png')) {
                      Fluttertoast.showToast(
                          msg: 'Selected file must be a .png image');
                      return;
                    }

                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child("images");
                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImageToUpload.putFile(File(image.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      // Handle error
                    }
                  },
                  child: Text(
                    tUpload.toUpperCase(),
                    style: TextStyles.loginButton,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ErrorScreen(),
                        ),
                      );
                      isloading = false;
                    } else {
                      setState(() {
                        isloading = true;
                      });

                      final DataModel data = await submitData(imageUrl);

                      setState(() {
                        _dataModel = data;
                        isloading =
                            false; // Set loading to false after data is fetched
                      });

                      Fluttertoast.showToast(msg: "Downloaded!");
                    }
                  },
                  child: isloading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          tSegment.toUpperCase(),
                          style: TextStyles.loginButton,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClickableIcon extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        auth.signOut().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnBoardingScreen(),
            ),
          );
        });
      },
      child: const Icon(
        Icons.logout,
        color: Colors.black,
      ),
    );
  }
}
