import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/widgets/task_item.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_format/date_time_format.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime now = DateTime.now();
  final TextEditingController controller = TextEditingController();
  Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = context.read<Tasks>().getTasksFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Text(
                "Todo",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text("${now.format('j.m.y')}"),
              FutureBuilder(
                future: futureTasks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tasks = context.watch<Tasks>().getTasks();
                    return Flexible(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return TaskItem(task: tasks[index]);
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  return CircularProgressIndicator();
                },
              )
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(50, 25, 50, 25),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedTextField(
                      hintText: "Write a new task",
                      controller: controller,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  RoundedIconButton(
                    icon: Icons.add,
                    onPressed: () {
                      context.read<Tasks>().addTask(controller.text);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  const RoundedIconButton({@required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const RoundedTextField({@required this.hintText, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.grey),
            hintText: hintText),
      ),
    );
  }
}
