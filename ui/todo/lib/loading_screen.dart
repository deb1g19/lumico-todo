import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks_model.dart';
import 'constants.dart';
import 'models/task_model.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool loaded = false;
  Future<List<TaskModel>> getTasksFromAPI() async {
    final response = await http.get('$kAPI_URL/api/tasks/');
    if (response.statusCode == 200) {
      var tasks = List.from(jsonDecode(response.body)["data"])
          .map((e) => TaskModel.fromJson(e))
          .toList();
      context.read<TasksModel>().initialise(tasks);
      return tasks;
    } else {
      throw Exception("Failed to get tasks");
    }
  }

  @override
  void initState() {
    super.initState();
    getTasksFromAPI().then((_) {
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? HomeScreen()
        : Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
  }
}
