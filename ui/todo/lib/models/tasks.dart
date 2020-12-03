import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:todo/models/task.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class Tasks extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(String taskText) async {
    if (taskText.isNotEmpty) {
      final http.Response response = await http.post('$kAPI_URL/api/task/',
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
        tasks.add(Task(
            completed: false,
            id: jsonDecode(response.body)['id'],
            text: taskText));
      }
    }
  }

  List<Task> getTasks() {
    return tasks;
  }

  Future<List<Task>> getTasksFromAPI() async {
    final response = await http.get('$kAPI_URL/api/tasks/');
    if (response.statusCode == 200) {
      tasks = List.from(jsonDecode(response.body)["data"])
          .map((e) => Task.fromJson(e))
          .toList();
      return tasks;
    } else {
      throw Exception("Failed to get tasks");
    }
  }

  void updateTaskStatus(Task task, bool completed) async {
    tasks[tasks.indexOf(task)].completed = completed;
    final http.Response response = await http.post(
      '$kAPI_URL/api/task/${task.id}/${completed ? 'complete' : 'incomplete'}',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    } else {
      notifyListeners();
    }
  }

  void deleteTask(Task task) async {
    tasks.remove(task);

    final http.Response response = await http.delete(
      "$kAPI_URL/api/task/${task.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      notifyListeners();
    }
  }
}
