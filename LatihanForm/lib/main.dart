import 'package:flutter/material.dart';
import 'package:statefulclickcounter/loginScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: LoginScreen()));
  }
}
