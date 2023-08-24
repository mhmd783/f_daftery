import 'package:daftery/detailes.dart';
import 'package:daftery/firstpage.dart';
import 'package:daftery/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool ref = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.green.shade600)),
      home: first(),
      routes: {
        "first": (context) => first(),
        "home": (context) => home(),
        "detailes": (context) => detailes()
      },
    );
  }
}
