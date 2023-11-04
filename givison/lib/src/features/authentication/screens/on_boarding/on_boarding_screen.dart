import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givison/src/constants/colors.dart';
import 'package:givison/src/constants/image_strings.dart';
import 'package:givison/src/constants/size.dart';
import 'package:givison/src/constants/text_strings.dart';
import 'package:givison/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}):super(key:key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late StreamSubscription subscription;
  var isDeviceConnected=false;
  bool isAlertSet=false;

  @override
  void initState(){
    getConnectivity();
    super.initState();
  }

  getConnectivity()=>
  subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  
  final controller=LiquidController();

  int currentPage =0;

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    

    return Scaffold(
      body:Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            liquidController: controller,
            onPageChangeCallback: onPageChangeCallback,
            slideIconWidget: Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
            pages:[
              Container(
                padding: const EdgeInsets.all(tDefaultSize),
                color: tOnboardingPage1Color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage(tOnBoardingImage1), height: size.height*0.4,),
                    Column(
                      children: [
                        Text(tOnBoardingTitle1, style: Theme.of(context).textTheme.displayMedium,textAlign:TextAlign.center,),
                        Text(tOnBoardingSubTitle1, textAlign:TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
                        Text(tOnboardingCounter1),
                        SizedBox(height: 70.0,)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(tDefaultSize),
                color: tOnboardingPage2Color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage(tOnBoardingImage2), height: size.height*0.4,),
                    Column(
                      children: [
                        Text(tOnBoardingTitle2, style: Theme.of(context).textTheme.displayMedium,textAlign:TextAlign.center,),
                        Text(tOnBoardingSubTitle2, textAlign:TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
                        Text(tOnboardingCounter2),
                        SizedBox(height: 60.0,)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(tDefaultSize),
                color: tOnboardingPage3Color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage(tOnBoardingImage3), height: size.height*0.4,),
                    Column(
                      children: [
                        Text(tOnBoardingTitle3, style: Theme.of(context).textTheme.displayMedium,textAlign:TextAlign.center,),
                        Text(tOnBoardingSubTitle3, textAlign:TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
                        Text(tOnboardingCounter3),
                        SizedBox(height: 60.0,)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 60.0,
            child: OutlinedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                foregroundColor: Colors.white
              ), 
              child: Container(
                padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: tDarkColor, shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward_ios),
              )
            ),
          ),
          Positioned(
            top:50,
            right: 20,
            child: TextButton(
              onPressed: (){
                controller.jumpToPage(page: 2);
              },
              child: const Text('Skip', style: TextStyle(color: Color.fromARGB(255, 26, 25, 25))),
            ),
          ),
          Positioned(
            bottom: 10,
            child:AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count:3,
              effect: const WormEffect(
                activeDotColor: Color(0xff272727),
                dotHeight: 5.0,
              ),
              
            )
          )
        ],
      )
    );
  }

  onPageChangeCallback(int activePageIndex){
    setState(() {
      currentPage=activePageIndex;
    });
    
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}