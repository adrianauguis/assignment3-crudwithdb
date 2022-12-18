import 'package:assignment_auguis_test/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'add_todo.dart';
import 'model/todo_model.dart';
import 'provider/todo_api_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBProvider? dbProvider;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbProvider = DBProvider();
    loadFromApi();
    loadData();
  }

  loadData() {
    dataList = dbProvider!.getTodoList();
  }

  loadFromApi() async {
    var apiProvider = TodoApiProvider();
    await apiProvider.getAllTodos();
  }

  bool toBoolean(String str, [bool strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  @override
  Widget build(BuildContext context) {
    bool todoStat;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
        leading: const Icon(Icons.code),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: dataList,
                  builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.length == 0) {
                      return const Center(
                        child: Text('No Todos'),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            int todoId = snapshot.data![index].id!.toInt();
                            String todoTitle =
                                snapshot.data![index].title!.toString();
                            // int todoUserId =
                            //     snapshot.data![index].userId!.toInt();
                            int? todoCompleted = snapshot.data![index].completed!.toInt();
                            todoStat = (todoCompleted == 1)? true : false;
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(color: Colors.red),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbProvider!.deleteTodo(todoId);
                                  dataList = dbProvider!.getTodoList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              child: CheckboxListTile(
                                  title: Text(todoTitle),
                                  subtitle: Text('ID: $todoId'),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  selected: todoStat,
                                  secondary: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddTodo(
                                                  todoId: todoId,
                                                  // todoUserId: todoUserId,
                                                  todoTitle: todoTitle,
                                                  todoUpdate: true,
                                                  todoStat: todoStat,
                                                )));
                                      },
                                      icon: const Icon(Icons.edit)),
                                value: todoStat,
                                onChanged: (value) {
                                    setState(() {
                                      todoStat = value!;
                                    });
                                },
                              ),
                            );
                            // trailing: Row(
                            //   children: <Widget>[
                            //     IconButton(onPressed: (){
                            //       Navigator.push(context,
                            //           MaterialPageRoute(
                            //               builder: (context)=>AddTodo(
                            //                 todoId: todoId,
                            //                 todoTitle: todoTitle,
                            //                 todoDesc: todoDesc,
                            //                 todoDateTime: todoDate,
                            //               )));
                            //     }, icon: const Icon(Icons.edit)),
                            //     IconButton(onPressed: (){
                            //       setState(() {
                            //         dbProvider!.deleteTodo(todoId);
                            //         dataList = dbProvider!.getTodoList();
                            //         snapshot.data!.remove(snapshot.data![index]);
                            //       });
                            //     }, icon: const Icon(Icons.delete))
                            //   ],
                            // ),
                          });
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTodo()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
