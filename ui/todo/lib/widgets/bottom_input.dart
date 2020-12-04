import 'package:flutter/material.dart';
import 'package:todo/widgets/rounded_icon_button.dart';
import 'package:todo/widgets/rounded_textfield.dart';

// A rounded input field with an IconButton styled for this project

class BottomInput extends StatelessWidget {
  const BottomInput(
      {Key key,
      @required this.controller,
      @required this.submit,
      @required this.submitIcon,
      this.buttonColor,
      this.buttonTextColor,
      @required this.hintText})
      : super(key: key);

  final TextEditingController controller;
  // Function called when the user submits text from the TextField
  final Function submit;
  final IconData submitIcon;
  final Color buttonColor;
  final Color buttonTextColor;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          Expanded(
            child: RoundedTextField(
                hintText: hintText,
                controller: controller,
                onSubmitted: (_) {
                  submit();
                  controller.clear();
                }),
          ),
          SizedBox(
            width: 20,
          ),
          RoundedIconButton(
              bgColor: buttonColor,
              textColor: buttonTextColor,
              onPressed: () {
                submit();
                FocusScope.of(context).unfocus();
              },
              icon: submitIcon)
        ],
      ),
    );
  }
}
