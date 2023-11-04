import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:givison/firebase_options.dart';
import 'package:givison/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:givison/src/repository/authentication_repository/authentication_repository.dart';
import 'package:givison/src/utils/theme/theme.dart';
import 'package:givison/src/features/authentication/screens/dashboard/dashboard.dart';

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
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: OnBoardingScreen(),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text(".appable/")),
      body: const Center(child: Text("Home Page")),
    );
  }
}

