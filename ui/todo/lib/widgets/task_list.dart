import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/constants.dart';
import 'package:todo/widgets/task_tile.dart';
import '../models/task.dart';
import 'dart:math';

class TaskList extends StatefulWidget {
  final Future<List<Task>> futureTasks;
  TaskList(this.futureTasks);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final random = new Random();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Task>>(
        future: widget.futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // If the API call was successful and we have data, build an animated list from the data
              // snapshot.data is a list of Task objects
              return snapshot.data.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/empty.png"),
                        ),
                        Text(
                          "It's quiet in here,\nadd some tasks!",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  : buildListView(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }

          // If there's not any data retreived yet, show a progress indicator
          return buildProgressIndicator();
        },
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Center(
        child: SizedBox(
            height: 25, width: 25, child: CircularProgressIndicator()));
  }

  Widget buildListView(List<Task> tasks) {
    return ListView.builder(
        key: listKey,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return buildTask(tasks[index], index);
        });
  }

  Widget buildTask(Task task, int index) {
    return Dismissible(
      key: UniqueKey(),
      child: buildListTile(task, index),
      background: Container(
        color: Colors.red[300],
      ),
      onDismissed: (direction) {
        removeItem(task);
      },
    );
  }

  Future<http.Response> removeItem(Task task) async {
    final http.Response response = await http.delete(
      "$kAPI_URL/api/task/${task.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  Widget buildListTile(Task task, int index) {
    return TaskTile(task);
  }
}
