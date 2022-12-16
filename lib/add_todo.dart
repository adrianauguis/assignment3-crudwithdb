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

  AddTodo({Key? key, this.todoId, this.todoTitle, this.todoDesc, this.todoDateTime})
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
    final title = TextEditingController(text: widget.todoTitle);
    final desc = TextEditingController(text: widget.todoDesc);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Todo'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      dbProvider!.insertTodo(TodoModel(
                          title: title.text,
                          desc: desc.text,
                          dateTime: DateFormat('yMd')
                              .add_jm()
                              .format(DateTime.now())
                              .toString()));
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> const HomePage()));
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
