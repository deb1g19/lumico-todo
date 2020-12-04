import 'package:flutter/material.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:provider/provider.dart';
import 'package:todo/widgets/task_item.dart';
import 'package:date_time_format/date_time_format.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  final DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var tasksModel = context.watch<TasksModel>();
    return Stack(
      children: [
        Column(
          children: [
            Text("Todo", style: Theme.of(context).textTheme.headline1),
            Text("${now.format('j.m.y')}",
                style: Theme.of(context).textTheme.subtitle1),
            tasksModel.tasks.length == 0
                ? Column(
                    children: [
                      Image.asset("images/empty.png"),
                      Text("It's empty in here. Add some tasks!")
                    ],
                  )
                : Container(
                    child: Flexible(
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: tasksModel.tasks.length,
                        itemBuilder: (context, index) {
                          return TaskItem(index);
                        },
                      ),
                    ),
                  )
          ],
        ),
        BottomInput(controller: controller, tasksModel: tasksModel)
      ],
    );
  }
}

class BottomInput extends StatelessWidget {
  const BottomInput(
      {Key key, @required this.controller, @required this.tasksModel})
      : super(key: key);

  final TextEditingController controller;
  final TasksModel tasksModel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [
            Expanded(
              child: RoundedTextField(
                  hintText: "Test task",
                  controller: controller,
                  onSubmitted: (_) {
                    tasksModel.addTask(controller.text);
                    controller.clear();
                  }),
            ),
            SizedBox(
              width: 20,
            ),
            RoundedIconButton(
                onPressed: () {
                  tasksModel.addTask(controller.text);
                  controller.clear();
                  FocusScope.of(context).unfocus();
                },
                icon: Icons.add)
          ],
        ),
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
  final Function onSubmitted;
  const RoundedTextField(
      {@required this.hintText,
      @required this.controller,
      @required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100)),
      child: TextField(
        onSubmitted: onSubmitted,
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
