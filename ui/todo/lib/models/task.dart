class Task {
  final String task;
  final int id;
  Task(this.id, this.task);
  // Construct a new Task instance from a map structure
  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        task = json['task'];

  Map<String, dynamic> toJson() => {'task': task};
}
