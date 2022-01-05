import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:live_admin_app/splash_screen.dart';
import 'pColor.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Admin App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: const MaterialColor(0xff00AE51, PColor.colorMap),
          canvasColor: Colors.transparent
      ),
      home: const SplashScreenPage(),
    );
  }
}
