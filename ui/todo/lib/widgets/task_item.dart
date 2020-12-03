import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/constants.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  TaskItem({Key key, @required this.task}) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool completed;
  @override
  void initState() {
    super.initState();
    completed = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            context.read<Tasks>().deleteTask(widget.task);
          });
        },
        child: Container(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              widget.task.text,
              style: completed
                  ? Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(decoration: TextDecoration.lineThrough)
                  : Theme.of(context).textTheme.bodyText1,
            ),
            onChanged: (value) {
              setState(() {
                completed = !completed;
              });
              context.read<Tasks>().updateTaskStatus(widget.task, completed);
            },
            value: completed,
          ),
        ),
      ),
    );
  }
}
