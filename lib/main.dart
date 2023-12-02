import "package:flutter/material.dart";


import 'first_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suivi médical',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: firstpage(),
    );
  }
}
