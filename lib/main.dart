import 'package:flutter/material.dart';
import 'package:news_app/homePage.dart';
import 'package:news_app/drawer.dart';
import 'package:news_app/routes.dart';
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