import 'package:flutter/material.dart';

import '../constants.dart';

// A padded circle with a centered Icon as the child, given as a parameter to the class constructor

class RoundIcon extends StatelessWidget {
  final IconData icon;
  const RoundIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: kOffWhite),
      child: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
