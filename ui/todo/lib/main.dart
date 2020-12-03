import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/loading_screen.dart';
import 'models/tasks_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TasksModel(), child: MyApp()));
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
                    fontFamily: "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                subtitle1: TextStyle(
                    color: Color(0xFF555B69),
                    fontFamily: "Inter",
                    fontSize: 18),
                headline1: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    color: Colors.black,
                    fontFamily: "Source Serif Pro"))),
        home: Scaffold(
          backgroundColor: Color(0xFFEDEDED),
          body: SafeArea(
            child: LoadingScreen(),
          ),
        ));
  }
}
