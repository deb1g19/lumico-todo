import 'package:flutter/material.dart';
import 'package:todo/widgets/round_icon.dart';
import 'package:date_time_format/date_time_format.dart';

// A Tasks icon, the title and the date in a row with some custom styling
// This is used at the top of all screens within the app

class TitleBar extends StatelessWidget {
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundIcon(Icons.event_note_outlined),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("ToDo", style: Theme.of(context).textTheme.headline1),
              Text(now.format('j.m.y'),
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          )
        ],
      ),
    );
  }
}
