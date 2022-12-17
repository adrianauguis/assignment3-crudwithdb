import 'package:assignment_auguis_test/home_page.dart';
import 'package:assignment_auguis_test/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/todo_model.dart';

class AddTodo extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDateTime;
  bool? todoUpdate;
  bool? todoStat;

  AddTodo(
      {Key? key,
      this.todoId,
      this.todoTitle,
      this.todoDesc,
      this.todoDateTime,
      this.todoUpdate,
      this.todoStat})
      : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
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


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int stat;
    String? appTitle;
    if (widget.todoUpdate == true) {
      appTitle = 'Update Todo';
      stat = (widget.todoStat == true)? 1 : 0;
    } else {
      appTitle = 'Add Todo';
      stat = 0;
    }

    final title = TextEditingController(text: widget.todoTitle);
    final desc = TextEditingController(text: widget.todoDesc);
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: title,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Title"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pleas Enter Some Text";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: desc,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Description"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pleas Enter Some Text";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Status",
                ),
                  items: const [
                DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                DropdownMenuItem(value: 'No', child: Text('No')),
              ],
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Please select instructor';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value == 'Yes'){
                      stat = 1;
                    }else{
                      stat = 0;
                    }
                  }
                  ),
              const SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.todoUpdate == true) {
                        dbProvider!.updateTodo(TodoModel(
                            id: widget.todoId,
                            title: title.text,
                            desc: desc.text,
                            status: stat,
                            dateTime: DateFormat('yMd')
                                .add_jm()
                                .format(DateTime.now())
                                .toString()));
                      } else {
                        dbProvider!.insertTodo(TodoModel(
                            title: title.text,
                            desc: desc.text,
                            status: stat,
                            dateTime: DateFormat('yMd')
                                .add_jm()
                                .format(DateTime.now())
                                .toString()));
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                      title.clear();
                      desc.clear();
                    }
                  },
                  child: const Text('Submit'))
            ],
          )),
    );
  }
}
