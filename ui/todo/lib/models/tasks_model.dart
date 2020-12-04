import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:todo/models/task_model.dart';
import 'package:http/http.dart' as http;

// Model for the list of tasks, with methods to interact with both the local copy (tasks) and the database simulataneously
class TasksModel extends ChangeNotifier {
  List<TaskModel> tasks = [];
  String serverURL = "";
  TasksModel();

  void initialise(List<TaskModel> newTasks) {
    tasks.addAll(newTasks);
  }

  void setServerURL(String ip) {
    serverURL = "http://$ip:8000";
  }

  void addTask(String taskText) async {
    if (taskText.isNotEmpty) {
      final http.Response response = await http.post('$serverURL/api/task/',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'task': taskText,
          }));

      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      } else {
        notifyListeners();
        tasks.add(TaskModel(
            completed: false,
            id: jsonDecode(response.body)['id'],
            text: taskText));
      }
    }
  }

  TaskModel getTaskAt(int index) {
    return tasks.elementAt(index);
  }

  void removeTaskAt(int index) async {
    final http.Response response = await http.delete(
      "$serverURL/api/task/${tasks[index].id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      tasks.removeAt(index);
      notifyListeners();
    }
  }

  void toggleTaskAt(int index) async {
    tasks.elementAt(index).completed = !tasks.elementAt(index).completed;
    notifyListeners();
    final http.Response response = await http.post(
      '$serverURL/api/task/${tasks[index].id}/${tasks[index].completed ? 'complete' : 'incomplete'}',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    } else {
      notifyListeners();
    }
  }

  Future<List<TaskModel>> getTasksFromAPI() async {
    final response = await http
        .get('$serverURL/api/tasks/')
        .timeout(Duration(seconds: 5), onTimeout: () {
      throw ("Connection failed");
    });
    if (response.statusCode == 200) {
      List<TaskModel> newTasks = List.from(jsonDecode(response.body)["data"])
          .map((e) => TaskModel.fromJson(e))
          .toList();
      tasks.addAll(newTasks);
    } else {
      throw ("Failed to get tasks");
    }
    return tasks;
  }
}
