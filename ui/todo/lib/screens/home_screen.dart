import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/models/task.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: context.watch<Tasks>().getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data[index].text);
                });
          } else {
            return Center(
                child: SizedBox(
                    width: 25, height: 25, child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
