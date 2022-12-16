import 'package:assignment_auguis_test/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'add_todo.dart';
import 'model/todo_model.dart';

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
    loadData();
  }

  loadData() {
    dataList = dbProvider!.getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
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
                            String todoTitle = snapshot.data![index].title!.toString();
                            String todoDesc = snapshot.data![index].desc!.toString();
                            String todoDate = snapshot.data![index].dateTime!.toString();
                            return ListTile(
                              title: Text(todoTitle),
                              subtitle: Text(todoDesc),
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
                            );
                          });
                    }
                  }))
        ],
      ),
      floatingActionButton:
      FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => AddTodo()));
      }, child: const Icon(Icons.add)),
    );
  }
}
