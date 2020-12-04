import 'package:flutter/material.dart';
import 'package:todo/constants.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:provider/provider.dart';
import 'package:todo/widgets/bottom_input.dart';
import 'package:todo/widgets/task_item.dart';
import 'package:todo/widgets/title_bar.dart';

// HomeScreen is the main 'notes page' of the app, where the user can view, delete and create notes
// The notes are taken from the NotesModel and displayed through a listview builder
// It would look nicer with an AnimatedList but implementing this with Dismissibles requires a workaround

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tasksModel = context.watch<TasksModel>();
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(children: [
        TitleBar(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            // Padding to compensate for border radius
            padding: EdgeInsets.only(top: 25),
            // A stack is used to have the textfield for creating new tasks float above the keyboard
            child: Stack(
              children: [
                Container(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: tasksModel.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(index);
                    },
                  ),
                ),
                // The input controls for creating a new task
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  child: BottomInput(
                    hintText: "Write a new task",
                    controller: controller,
                    submit: () {
                      tasksModel.addTask(controller.text);
                      controller.clear();
                    },
                    submitIcon: Icons.add,
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
