import 'package:flutter/material.dart';

// An IconButton with a circular coloured background

class RoundedIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const RoundedIconButton(
      {@required this.onPressed,
      @required this.icon,
      this.bgColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor != null ? bgColor : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: textColor != null ? textColor : Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
