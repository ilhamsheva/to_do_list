class TodoModel {
  String title;
  String description;
  String date;
  bool isDone;

  TodoModel({
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });
}
