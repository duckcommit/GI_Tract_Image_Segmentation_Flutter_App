import 'package:flutter/material.dart';
import 'package:givison/common/size.dart';
import 'package:givison/common/text_strings.dart';
import 'package:lottie/lottie.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Replace the Image widget with Lottie.asset
            Lottie.asset(
              'assets/images/emailsent.json', // Adjust path if needed
              height: height * 0.6,
              repeat: false,
            ),
            Column(
              children: [
                Text(
                  tpw,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,),// Match text style
                  textAlign: TextAlign.center,
                ),
                Text(
                  tpws,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20.0,), // Match text style
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
