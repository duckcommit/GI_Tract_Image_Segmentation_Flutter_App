//NOT USED ANYMORE

import 'package:flutter/material.dart';
import 'package:givison/common/image_strings.dart';
import 'package:givison/common/size.dart';
import 'package:givison/common/text_strings.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children:[
          Positioned(
            top:80,
            left:tDefaultSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(tAppName, style: Theme.of(context).textTheme.headlineMedium,),
                Text(tAppTagLine, style: Theme.of(context).textTheme.headlineSmall,),
              ]   
            ),
          ),
          const Positioned(
            bottom:40,
            left:0,
            child: Image(image: AssetImage(tSplashImage)),
          )
        ],
      )
    );
  }
}