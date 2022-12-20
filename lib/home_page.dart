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
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbProvider = DBProvider();
    dbProvider!.deleteDatabase();
  }

  buildTodoListView() {
    dataList = dbProvider!.getTodoList();
    return Column(
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
                          int? todoCompleted =
                              snapshot.data![index].completed!.toInt();
                          bool todoStat = (todoCompleted == 1) ? true : false;
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
                              value: todoStat,
                              onChanged: (value) {
                                setState(() {
                                  todoStat = value!;
                                });
                              },
                              secondary: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddTodo(
                                                  todoId: todoId,
                                                  todoTitle: todoTitle,
                                                  todoUpdate: true,
                                                  todoStat: todoStat,
                                                )));
                                  },
                                  icon: const Icon(Icons.edit)),
                            ),
                          );
                        });
                  }
                }))
      ],
    );
  }

  loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = TodoApiProvider();
    await apiProvider.getAllTodos();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
        leading: const Icon(Icons.code),
        actions: [
          IconButton(
              onPressed: () async {
                await loadFromApi();
              },
              icon: const Icon(Icons.settings_input_antenna))
        ],
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : buildTodoListView(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTodo()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
