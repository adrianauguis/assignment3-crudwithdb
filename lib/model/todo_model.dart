class TodoModel {
  final int? id;
  final String? title;
  final int? completed;

  TodoModel({this.id,
    this.title,
    this.completed});

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
    id: json["id"],
    title: json["title"],
    completed: json["completed"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "completed": completed
  };
}
