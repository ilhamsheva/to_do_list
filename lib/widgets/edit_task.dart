import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/todo.dart';
import 'package:intl/intl.dart'; // Add this import

class EditTaskScreen extends StatefulWidget {
  final int taskIndex;
  final String newTitle;
  final String newDescription;
  final String newDate;

  const EditTaskScreen({
    super.key,
    required this.taskIndex,
    required this.newTitle,
    required this.newDescription,
    required this.newDate,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskController.text = widget.newTitle;
    _descriptionController.text = widget.newDescription;
    _dateController.text = widget.newDate;
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _showEditTaskDialog(BuildContext context) async {
    final todos = Provider.of<Todos>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
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
                  // Use the injected Todo provider to update task
                  todos.editTask(
                    widget.taskIndex,
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
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
              ),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showEditTaskDialog(context); // Call the dialog
              },
              child: const Text("Edit Task"),
            ),
          ],
        ),
      ),
    );
  }
}
