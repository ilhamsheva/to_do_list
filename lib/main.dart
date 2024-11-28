import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './widgets/todo_screen.dart';
import './providers/todo.dart';

void main() {
  runApp(
      Theme(data: ThemeData(primarySwatch: Colors.cyan), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Todos>(
      create: (context) => Todos(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: TodoScreen(),
      ),
    );
  }
}
