class TodoModel {
  final int? id;
  final String? title;
  final String? desc;
  final String? dateTime;

  TodoModel({this.id,
    this.title,
    this.desc,
    this.dateTime});

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
    id: json["id"],
    title: json["title"],
    desc: json["desc"],
    dateTime: json["dateTime"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "desc": desc,
    "dateTime": dateTime,
  };
}
