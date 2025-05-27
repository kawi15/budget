import 'package:flutter/material.dart';

import '../main_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((_) {
      return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Icon(Icons.monetization_on_rounded, color: Colors.greenAccent, size: 128)
      ),
    );
  }


}
