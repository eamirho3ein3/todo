import 'package:flutter/material.dart';
import 'package:todo/pages/home/home.dart';

void main() {
  runApp(Todo());
}

class Todo extends StatefulWidget {
  const Todo({key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
