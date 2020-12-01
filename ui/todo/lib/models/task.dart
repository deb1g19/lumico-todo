class Task {
  final String text;
  final int id;
  bool completed;
  Task(this.id, this.text, this.completed);
  // Construct a new Task instance from a map structure
  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['task'],
        completed = json['completed'] == 1 ? true : false;

  Map<String, dynamic> toJson() => {'task': text};
}
