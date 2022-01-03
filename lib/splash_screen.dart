import 'package:flutter/material.dart';
import 'package:live_admin_app/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) =>
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset('assets/logo/splash_image.png'),
        ),
      ),
    );
  }
}
