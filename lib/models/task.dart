import 'package:flutter/material.dart';

final String tasksTable = 'tasks';

class TasksFields {
  static final List<String> values = [id, title, description, creatDate];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String creatDate = 'creatDate';
}

class TaskModel {
  final int id;
  final String title;
  final String description;
  final DateTime creatDate;

  TaskModel({
    this.id,
    @required this.title,
    @required this.description,
    @required this.creatDate,
  });

  TaskModel copy({
    int id,
    String title,
    String description,
    DateTime creatDate,
    DateTime dueDate,
  }) =>
      TaskModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        creatDate: creatDate ?? this.creatDate,
      );

  Map<String, Object> toJson() => {
        TasksFields.id: id,
        TasksFields.title: title,
        TasksFields.description: description,
        TasksFields.creatDate: creatDate.toIso8601String(),
      };

  static TaskModel fromJson(Map<String, Object> json) => TaskModel(
        id: json[TasksFields.id] as int,
        title: json[TasksFields.title] as String,
        description: json[TasksFields.description] as String,
        creatDate: DateTime.parse(json[TasksFields.creatDate] as String),
      );
}
