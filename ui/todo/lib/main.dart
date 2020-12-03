import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/home_screen.dart';
import 'models/tasks.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => Tasks(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              subtitle1: TextStyle(
                  color: Color(0xFF555B69),
                  fontWeight: FontWeight.w300,
                  fontSize: 18),
              headline1: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.black))),
      home: Scaffold(
        backgroundColor: Color(0xFFEDEDED),
        body: HomeScreen(),
      ),
    );
  }
}
