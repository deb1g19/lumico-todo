import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants.dart';
import 'package:todo/screens/ip_screen.dart';
import 'package:todo/screens/loading_screen.dart';
import 'models/tasks_model.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

// Main handles some project metadata and route creation for navigation

void main() {
  // The provider for TasksModel is instantiated here to provide access to this TasksModel instance
  // for widgets lower in the widget tree.
  runApp(ChangeNotifierProvider(
      create: (context) => TasksModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Status bar color is usually determined by scaffold, but scaffold color is not the same as the bg at the top of the screen, so this looks more natural
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue);
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              subtitle1: TextStyle(
                  color: kOffWhite, fontSize: 15, fontWeight: FontWeight.w400),
              headline1: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 40,
                color: kOffWhite,
              ))),
      routes: {
        "/": (context) => Scaffold(
              backgroundColor: kOffWhite,
              body: SafeArea(
                child: IPScreen(),
              ),
            ),
        "/loading_screen": (context) => LoadingScreen()
      },
    );
  }
}
