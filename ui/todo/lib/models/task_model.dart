class TaskModel {
  final String text;
  int id;
  bool completed;
  TaskModel({this.text, this.id, this.completed});

  void toggleCompleted() {
    completed = !completed;
  }

  TaskModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['task'],
        completed = json['completed'] == 1 ? true : false;

  Map<String, dynamic> toJson() => {'task': text};
}
