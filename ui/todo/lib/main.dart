import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/constants.dart';

import 'models/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ServerTest(),
    );
  }
}

class ServerTest extends StatelessWidget {
  const ServerTest({Key key}) : super(key: key);

  Future<Task> fetchTasks() async {
    final response = await http.get("$kAPI_URL /api/tasks/");

    if (response.statusCode == 200) {
      // If we get a 200 response from the server, nothing went wrong
      print(jsonDecode(response.body));
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get tasks");
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchTasks();
    return Container(
        child: Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [Text("Hello")],
          ),
        ),
      ),
    ));
  }
}
