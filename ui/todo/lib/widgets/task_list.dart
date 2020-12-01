import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/constants.dart';
import 'dart:convert';
import '../models/task.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<List<Task>> futureTasks;
  @override
  void initState() {
    super.initState();
    // Fetch tasks in initState so that it is run exactly once. This prevents unneccessary API calls.
    futureTasks = fetchTasks();
  }

  Future<List<Task>> fetchTasks() async {
    final response = await http.get("$kAPI_URL /api/tasks/");
    // If we get a 200 response from the server, nothing went wrong
    if (response.statusCode == 200) {
      // Map the json to Task objects
      var tasks = List.from(jsonDecode(response.body)["data"])
          .map((e) => Task.fromJson(e))
          .toList();
      return tasks;
    } else {
      throw Exception("Failed to get tasks");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the API call was successful and we have data, build an animated list from the data
            // snapshot.data is a list of Task objects
            return AnimatedList(
                initialItemCount: snapshot.data.length,
                itemBuilder: (context, index, animation) {
                  return SlideInLeft(child: Text(snapshot.data[index].task));
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // If there's not any data retreived yet, show a progress indicator
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
