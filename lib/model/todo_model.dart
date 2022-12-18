class TodoModel {
  final int? id;
  // final int? userId;
  final String? title;
  final int? completed;

  TodoModel({this.id,
    this.title,
    // this.userId,
    this.completed});

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
      // userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"]
  );

  Map<String, dynamic> toMap() => {
    // "userId": userId,
    "id": id,
    "title": title,
    "completed": completed
  };
}
