import 'package:flutter/material.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks_model.dart';
import '../models/task_model.dart';

// Loading screen uses a futureBuilder to get tasks from the api,
// providing a loading indicator whilst the async method getTasksFromAPI() is runnning.
// Once ready, the home screen is created using the tasks.

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<List<TaskModel>> futureTasks;
  @override
  void initState() {
    super.initState();
    // This widget does not need to be rebuilt when the database data changes as
    // once we've instantiated the TasksModel from the exisiting data, any changes
    // can be made both locally and via the database. The benefit of this is that
    // we don't need to show a loading indicator after creating/deleting a task.
    futureTasks = context.read<TasksModel>().getTasksFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureTasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        } else {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
