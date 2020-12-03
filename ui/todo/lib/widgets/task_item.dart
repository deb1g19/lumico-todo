import 'package:flutter/material.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatefulWidget {
  final int index;
  TaskItem(this.index);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    var tasksModel = context.watch<TasksModel>();
    bool pressed = tasksModel.getTaskAt(widget.index).completed;
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        tasksModel.removeTaskAt(widget.index);
      },
      child: CheckboxListTile(
        value: pressed,
        onChanged: (value) {
          tasksModel.toggleTaskAt(widget.index);
        },
        title: pressed
            ? Text(
                tasksModel.getTaskAt(widget.index).text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(decoration: TextDecoration.lineThrough),
              )
            : Text(tasksModel.getTaskAt(widget.index).text,
                style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }
}
