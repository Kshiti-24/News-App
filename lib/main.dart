import 'package:flutter/material.dart';
import 'package:newsapp/homePage.dart';
import 'package:newsapp/model.dart';
import 'package:newsapp/drawer.dart';
import 'package:newsapp/routes.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        MyRoutes.drawerRoute: (context) => MyDrawer(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}