import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:givison/firebase_options.dart';
import 'package:givison/screens/on_boarding/on_boarding.screen.dart';
import 'package:givison/authentication_repository.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthenticationRepository()));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}):super(key:key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnBoardingScreen(),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
    );
  }
}

