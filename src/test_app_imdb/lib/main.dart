import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app_imdb/homepage.dart';

void main() => runApp(myApp());

class myApp extends StatefulWidget
{
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {

  @override
  Widget build(BuildContext context)
  {

    return MediaQuery(
      data: new MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "My App",
        home: HomePage(),
      ),
    );
  }
}







