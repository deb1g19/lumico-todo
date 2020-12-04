import 'package:flutter/material.dart';

// A TextField with rounded corners and no border or label

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
        style: Theme.of(context).textTheme.bodyText1,
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
