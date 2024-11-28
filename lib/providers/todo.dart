import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:todolist/models/todo_model.dart'; // Assuming the TodoModel is in a separate file

class Todos with ChangeNotifier {
  List<TodoModel> _todos = [];

  List<TodoModel> get todo {
    return _todos;
  }

  void addTask(String title, String description, String date) {
    _todos.add(TodoModel(title: title, description: description, date: date));
    notifyListeners();
  }

  void deleteTask(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void todoStatus(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    notifyListeners();
  }

  void filterTasks(bool showOnlyCompleted) {
    if (showOnlyCompleted) {
      _todos = _todos.where((todo) => todo.isDone).toList();
    } else {
      _todos = [..._todos]; // Reset to original list
    }
    notifyListeners();
  }

  // Edit a task by its index
  void editTask(int index, String newTitle, String newDescription, String newDate) {
    if (index >= 0 && index < _todos.length) {
      _todos[index].title = newTitle;
      _todos[index].description = newDescription;
      _todos[index].date = newDate;
      notifyListeners();
    }
  }
}
