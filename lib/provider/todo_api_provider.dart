import 'package:dio/dio.dart';

import '../model/todo_model.dart';
import 'db_provider.dart';

class TodoApiProvider {
  Future<List<TodoModel?>> getAllTodos() async {
    DBProvider dbProvider = DBProvider();
    var url = "https://jsonplaceholder.typicode.com/todos";
    Response response = await Dio().get(url);

    return (response.data as List).map((items) {
      int stat = items['completed'] == true ? 1 : 0;
      items['completed'] = stat;
      print('Inserting $items');
      dbProvider.insertTodo(TodoModel.fromMap(items));
    }).toList();
  }
}
