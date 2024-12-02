class Task {
  String id;
  String title;
  String description;
  String priority;
  String categoryId;
  String dueAt;
  bool status;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.categoryId,
      required this.dueAt,
      this.status = false});
}
