import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/constants.dart';
import 'package:todo/models/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  TaskTile(this.task);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isPressed = false;
  @override
  void initState() {
    isPressed = widget.task.completed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: buildCheckboxTile(),
    );
  }

  Widget buildCheckboxTile() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        widget.task.text,
        style: isPressed
            ? Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(decoration: TextDecoration.lineThrough)
            : Theme.of(context).textTheme.bodyText1,
      ),
      value: isPressed,
      onChanged: (bool value) {
        setState(() {
          toggleTask(value);
          isPressed = !isPressed;
        });
      },
    );
  }

  Future<Task> toggleTask(bool completed) async {
    final http.Response response = await http.post(
      '$kAPI_URL/api/task/${widget.task.id}/${completed ? 'complete' : 'incomplete'}',
    );
    if (response.statusCode == 200) {
      // If the task was update successfully, return the output
      return Task.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not update the task successfully, throw an exception.
      throw Exception('Failed to update task');
    }
  }
}
