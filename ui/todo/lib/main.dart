import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/constants.dart';
import 'package:todo/widgets/task_list.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:http/http.dart' as http;
import 'models/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              subtitle1: TextStyle(
                  color: Color(0xFF555B69),
                  fontWeight: FontWeight.w300,
                  fontSize: 18),
              headline1: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.black))),
      home: Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        body: SafeArea(child: NotesPage()),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  NotesPage({Key key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController textController = TextEditingController();
  bool isEditing = false;
  Future<List<Task>> futureTasks;
  @override
  void initState() {
    futureTasks = fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    return Stack(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(time.hour < 12 ? "Good morning" : "Good afternoon",
                        style: Theme.of(context).textTheme.headline1),
                    Text(
                      "${time.format('l, j M')}",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              Expanded(child: TaskList(futureTasks)),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                buildInputBubble(),
                SizedBox(
                  width: 15,
                ),
                buildSubmitIconButton()
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<List<Task>> fetchTasks() async {
    final response = await http.get("$kAPI_URL/api/tasks/");
    // If we get a 200 response from the server, nothing went wrong
    if (response.statusCode == 200) {
      // Map the json to Task objects
      var tasks = List.from(jsonDecode(response.body)["data"])
          .map((e) => Task.fromJson(e))
          .toList();
      return tasks;
    } else {
      throw Exception("Failed to get tasks");
    }
  }

  Container buildSubmitIconButton() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          color: isEditing ? Colors.lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(50)),
      child: IconButton(
        color: isEditing ? Colors.white : Colors.black,
        icon: Icon(Icons.done),
        onPressed: () {
          createTask(textController.text);
        },
      ),
    );
  }

  Expanded buildInputBubble() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: TextField(
          decoration: InputDecoration.collapsed(hintText: "Write a new task"),
          style: Theme.of(context).textTheme.bodyText1,
          controller: textController,
          onTap: () {
            setState(() {
              isEditing = true;
            });
          },
          onSubmitted: (String value) {
            createTask(value);
          },
        ),
      ),
    );
  }

  Future<Task> createTask(String task) async {
    setState(() {
      isEditing = false;
    });
    textController.clear();
    FocusScope.of(context).unfocus();
    if (task.length == 0) {
      return null;
    }
    final http.Response response = await http.post('$kAPI_URL/api/task/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'task': task,
        }));
    if (response.statusCode == 200) {
      // If the task was update successfully, return the output
      setState(() {
        futureTasks = fetchTasks();
      });
      return Task.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not update the task successfully, throw an exception.
      throw Exception('Failed to update task');
    }
  }
}
