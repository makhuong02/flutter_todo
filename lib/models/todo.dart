class Todo {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}
