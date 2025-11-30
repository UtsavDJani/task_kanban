/*
class Board {
  String title;
  List<String> tasks;

  Board(this.title, this.tasks);

  Board copyWith({String? title, List<String>? tasks}) {
    return Board(
      title ?? this.title,
      tasks ?? List<String>.from(this.tasks),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:task_kanban/models/task_model.dart';

class Board {
  String title;
  List<Task> tasks;
  Color color;
  IconData icon;

  Board({
    required this.title,
    required this.tasks,
    required this.color,
    required this.icon,
  });

  Board copyWith({
    String? title,
    List<Task>? tasks,
    Color? color,
    IconData? icon,
  }) {
    return Board(
      title: title ?? this.title,
      tasks: tasks ?? List<Task>.from(this.tasks),
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}