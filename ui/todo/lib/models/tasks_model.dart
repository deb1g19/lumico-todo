import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:todo/models/task_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TasksModel extends ChangeNotifier {
  List<TaskModel> tasks = [];
  TasksModel();
  void initialise(List<TaskModel> newTasks) {
    tasks.addAll(newTasks);
  }

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
      "$kAPI_URL/api/task/${tasks[index].id}",
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
      '$kAPI_URL/api/task/${tasks[index].id}/${tasks[index].completed ? 'complete' : 'incomplete'}',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    } else {
      notifyListeners();
    }
  }

  Future<List<TaskModel>> getTasksFromAPI() async {
    final response = await http.get('$kAPI_URL/api/tasks/');
    if (response.statusCode == 200) {
      List<TaskModel> newTasks = List.from(jsonDecode(response.body)["data"])
          .map((e) => TaskModel.fromJson(e))
          .toList();
      tasks.addAll(newTasks);
      return tasks;
    } else {
      throw Exception("Failed to get tasks");
    }
  }
}
