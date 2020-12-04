import 'package:flutter/material.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:todo/widgets/rounded_icon_button.dart';
import 'package:todo/widgets/rounded_textfield.dart';

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
