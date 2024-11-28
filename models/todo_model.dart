import 'package:flutter/material.dart';

class TodoModel {
  @required
  String title;
  @required
  String description;
  @required
  bool isCompleted;

  TodoModel(
      {required this.title,
      required this.description,
      this.isCompleted = false});
}
