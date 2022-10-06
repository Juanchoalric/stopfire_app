import 'package:flutter/material.dart';
import 'package:stopfire/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), (){});
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context)=> const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("StopFire",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
