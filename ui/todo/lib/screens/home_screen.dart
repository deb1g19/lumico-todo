import 'package:flutter/material.dart';
import 'package:todo/constants.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:provider/provider.dart';
import 'package:todo/widgets/bottom_input.dart';
import 'package:todo/widgets/round_icon.dart';
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
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const RoundIcon(Icons.event_note_outlined),
              buildTitleDate(context, now.format('j.m.y'))
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            // Padding to compensate for border radius
            padding: EdgeInsets.only(top: 25),
            child: Stack(
              children: [
                tasksModel.tasks.length == 0
                    ? buildEmpty()
                    : Container(
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: tasksModel.tasks.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                              child: TaskItem(index),
                            );
                          },
                        ),
                      ),
                BottomInput(controller: controller, tasksModel: tasksModel)
              ],
            ),
          ),
        )
      ]),
    );
  }

  Column buildTitleDate(BuildContext context, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Todo", style: Theme.of(context).textTheme.headline1),
        Text(date, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }

  Column buildEmpty() {
    return Column(
      children: [
        Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset("images/emptylist.png"))),
        Text("It's empty in here. Add some tasks!")
      ],
    );
  }
}
