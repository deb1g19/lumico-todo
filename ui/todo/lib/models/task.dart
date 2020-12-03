import 'package:flutter/material.dart';

class Task {
  final String text;
  final int id;
  bool completed;
  Task({@required this.id, @required this.text, @required this.completed});
  // Construct a new Task instance from a map structure
  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['task'],
        completed = json['completed'] == 1 ? true : false;

  Map<String, dynamic> toJson() => {'task': text};
}
