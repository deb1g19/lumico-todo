import 'package:flutter/material.dart';
import 'package:todo/constants.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:todo/widgets/bottom_input.dart';
import 'package:todo/widgets/title_bar.dart';
import 'package:provider/provider.dart';

// IP screen takes the IP of the user's server to allow for the app to run on any server
// This was implemented as my PC uses a non-static IP so I can't hard code
// the server URL.

class IPScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  IPScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          TitleBar(),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              // BottomInput has a default padding of 25
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: BottomInput(
                hintText: "Enter server IP",
                controller: controller,
                submitIcon: Icons.arrow_forward,
                submit: () {
                  if (controller.text.length > 0) {
                    context.read<TasksModel>().setServerURL(controller.text);
                    Navigator.pushReplacementNamed(context, '/loading_screen');
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
