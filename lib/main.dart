import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        initialRoute: '/login',
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new Login(),
          '/home': (BuildContext context) => new Home(),
        });
  }
}
