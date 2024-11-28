import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/todo.dart';
import 'package:intl/intl.dart';
import 'package:todolist/widgets/edit_task.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Variable to control the displayed content in the body
  bool _showAllTasks = true;

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<Todos>(context);

    var showAll = Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: todos.todo.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              setState(() {});

              // Display the popup menu
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 100, 100),
                items: [
                  PopupMenuItem<String>(
                    value: 'Edit Task',
                    child: const Text('Edit Task'),
                    onTap: () {
                      // Schedule navigation outside the popup to avoid black screen
                      Future.delayed(const Duration(milliseconds: 0), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(
                              taskIndex: index,
                              newTitle: todos.todo[index].title,
                              newDescription: todos.todo[index].description,
                              newDate: todos.todo[index].date,
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  const PopupMenuItem<String>(
                    value: 'See Task Done',
                    child: Text('See Task Done'),
                  ),
                ],
              );
            },
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(todos.todo[index].title),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(todos.todo[index].description),
                        Text(todos.todo[index].date),
                      ],
                    ),
                  );
                },
              );
            },
            child: ListTile(
              title: Text(todos.todo[index].title),
              subtitle: Text(todos.todo[index].description),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        centerTitle: true,
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: const Icon(Icons.accessible),
            onPressed: () {
              // Toggle between showing all tasks and other content
              setState(() {
                _showAllTasks = !_showAllTasks;
              });
            },
          ),
        ],
      ),
      body: _showAllTasks ? showAll : const Center(child: Text("No Tasks")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          keluar(context, todos);
        },
        backgroundColor: const Color.fromARGB(255, 21, 95, 12),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> keluar(BuildContext context, Todos todos) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  hintText: 'Enter task title',
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter task description',
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty) {
                  todos.addTask(
                    _taskController.text,
                    _descriptionController.text,
                    _dateController.text,
                  );
                  _taskController.clear();
                  _descriptionController.clear();
                  _dateController.clear();
                } else {
                  String errorMessage;
                  if (_taskController.text.isEmpty) {
                    errorMessage = "Task is required";
                  } else if (_descriptionController.text.isEmpty) {
                    errorMessage = "Description is required";
                  } else if (_dateController.text.isEmpty) {
                    errorMessage = "Date is required";
                  } else {
                    errorMessage = "Please fill in all fields";
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
